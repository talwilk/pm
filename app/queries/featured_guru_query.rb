class FeaturedGuruQuery
  def results
    advices = DilemmaAdvice.order('dilemma_advices.created_at desc').includes(:user).where('users.role = ?', 'guru').references(:user)
    featured_gurus = []
    advices.each { |advice| featured_gurus << advice.user }
    featured_gurus = featured_gurus.uniq
    featured_gurus.map{ |i| i.id }
    results = User.where(id: featured_gurus).first(3)
    results
  end
end
