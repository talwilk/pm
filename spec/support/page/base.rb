module Page
  class Base
    include Rails.application.routes.url_helpers
    include Capybara::DSL

    def self.form_resource(name, options = {})
      @form_resource = { :resource => name }.merge(options)
    end

    def self.form_field(attribute, options = {})
      @form_fields ||= {}
      if attribute.is_a?(Array)
        attribute = attribute.join('//')
      end
      @form_fields[attribute] = options
    end

    def self.get_form_field(attribute, options = {})
      field = @form_resource || {}

      if options[:nested].present?
        attribute = (options[:nested] + [attribute]).join('//')
      end

      if @form_fields && @form_fields.has_key?(attribute)
        field = field.merge @form_fields[attribute]
      end

      field
    end

    def fill_in(attributes, overrides = {})
      return super if overrides[:with]

      @max_debounce = 0

      fill_in_recursive(attributes, overrides)

      sleep overrides[:debounce] || @max_debounce
    end

    def field_value(attribute, overrides = {})
      options = self.class.get_form_field(attribute).merge(overrides)

      if attribute.is_a?(Hash)
        return field_value(attribute.values.first,
                           :nested => Array(options[:nested]) + [attribute.keys.first])
      end

      selector = resolve_field_selector(attribute, options)
      find_field(selector).value
    end

    def field_selector(attribute, overrides = {})
      if attribute.is_a?(Hash)
        nested = attribute.first[1]
        attribute = attribute.first[0]
      end

      options = self.class.get_form_field(attribute, nested: overrides[:nested]).merge(overrides)

      unless nested.blank?
        return field_selector(nested, :nested => Array(options[:nested]) + [attribute])
      end

      resolve_field_selector(attribute, options)
    end

    def default_url_options
      Rails.application.routes.default_url_options
    end

    def click_list_item_actions_dropdown
      find('.actions.dropdown > a').click
    end

    protected

    def set_select_field_value(selector, value)
      within "select[name='#{selector}']" do
        find("option[value='#{value}']").select_option
      end
    end

    def set_selectize_field_value(selector, value)
      within "div[name='#{selector}']" do
        find('.selectize-input').click
        find('.selectize-input').native.send_keys(:Backspace, :Space)

        if value.present?
          if value.is_a?(Array) && value.length == 2 && value.first == :add
            add_selectize_field_option(value.last)
          else
            find(".selectize-dropdown div[data-value='#{value}']").click
          end
        end
      end
    end

    def set_selectize_by_name_field_value(selector, value)
      within "div[name='#{selector}']" do
        find('.selectize-input').click
        find('.selectize-input').native.send_keys(:Backspace, :Space)

        if value.present?
          first(".selectize-dropdown div", text: value).click
        end
      end
    end

    def set_selectize_simple_form_field_value(selector, value)
      within find("select[name='#{selector}']", visible: false).find(:xpath, '..') do
        find('.selectize-input').click
        find('.selectize-input').native.send_keys(:Backspace, :Space)

        if value.present?
          find(".selectize-dropdown div[data-value='#{value}']").click
        end
      end
    end

    def add_selectize_field_option(text)
      find('.selectize-input').native.send_keys(text)
      find('.selectize-dropdown-content .create').click

      20.times do |t|
        if first('.selectize-input .item').try(:text) == text &&
          first('.selectize-input .item').try(:[], 'data-value').present?
          break
        end

        if t == 19
          raise "Unable to add the '#{text}' selectize option"
        else
          sleep 0.1
        end
      end
    end

    def set_froala_field_value(selector, value)
      within find("textarea[name='#{selector}']", visible: false).find(:xpath, '..') do
        wrapper = find('.fr-wrapper')
        wrapper.click
        wrapper.native.send_keys(value)
      end
    end

    def set_date_picker_field_value(selector, value)
      page.execute_script("$(\"input[name='#{selector}']\").val('#{value}')")
    end

    def set_checkbox_field_value(selector, value)
      if value
        check selector
      else
        uncheck selector
      end
    end

    def set_checkbox_array_field_value(selector, values, label_clicked_type = false)
      if values.is_a?(Array)
        filled = all(:css, "input[name='#{selector}[]']").map do |field|
          field['value'].to_i.tap do |value|
            will_be_checked = value.in?(values)

            if label_clicked_type
              field.find(:xpath, './/following-sibling::label[1]').click if field.checked? != will_be_checked
            else
              field.set will_be_checked
            end
          end
        end
      else
        filled = all(:css, "input[name='#{selector}']").map do |field|
          field['value'].to_i.tap do |value|
            will_be_checked = value == values

            if label_clicked_type
              field.find(:xpath, './/following-sibling::label[1]').click if field.checked? != will_be_checked
            else
              field.set will_be_checked
            end
          end
        end
      end

      if (left = Array(values) - filled).any?
        raise "Unable to locate checboxes for values: #{left.join(', ')}"
      end
    end

    def set_checkbox_array_label_clicked_field_value(selector, values)
      set_checkbox_array_field_value(selector, values, true)
    end


    def set_text_field_value(selector, value)
      fill_in selector, with: value
    end

    def set_file_field_value(selector, value)
      if value.is_a?(File) || value.is_a?(Rack::Test::UploadedFile)
        attach_file selector, value.path
      else
        raise(ArgumentError, "unable to attach file: #{value.inspect}")
      end
    end

    def set_radio_buttons_field_value(selector, value)
      choose "#{selector.gsub(/[\[\]]/, '_')}#{value}"
    end

    def set_field_value(selector, value, options = {})
      as = options[:as]
      as = :checkbox if !as && (value == true || value == false)
      as = :file if !as && (value.is_a?(File))
      as ||= :text

      send("set_#{as}_field_value", selector, value)
    end

    def resolve_field_selector(attribute, options)
      if options[:label]
        options[:label]
      elsif options[:resource]
        if options[:nested]
          nested_name = Array(options[:nested]).map { |i| "[#{i}]" }.join

          "#{options[:resource]}#{nested_name}[#{attribute}]"
        else
          "#{options[:resource]}[#{attribute}]"
        end
      else
        attribute.to_s.humanize
      end
    end

    def in_locale(locale)
      current_locale = I18n.locale
      FastGettext.locale = I18n.locale = locale
      yield
      FastGettext.locale = I18n.locale = current_locale
    end

    private

    def fill_in_recursive(attributes, overrides = {})
      attributes.each do |attribute, value|
        options = self.class.get_form_field(attribute, nested: overrides[:nested]).merge(overrides)

        if value.is_a?(Hash)
          next fill_in_recursive(value, nested: Array(options[:nested]) + [attribute])
        end

        selector = resolve_field_selector(attribute, options)

        debouncable = first(:css, "input[name='#{selector}']")
        if debouncable
          debounce_match = debouncable['ng-model-options'].to_s.match(/debounce:.*?(\d+)/)
          if debounce_match
            @max_debounce = [@max_debounce, debounce_match[1].to_i * 1e-3].max
          end
        end

        set_field_value(selector, value, options)
      end
    end
  end
end
