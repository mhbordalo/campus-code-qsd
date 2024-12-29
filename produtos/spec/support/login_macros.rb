def login
  user = User.create!(name: 'admin', email: 'admin@locaweb.com.br', password: '123456')
  login_as(user, scope: :user)
end
