11.times do
    User.create(
        login: Faker::Internet.username, 
        name: Faker::Name.name)

    Store.create(
        name: Faker::Address.community, 
        number: Faker::Number.number, 
        address: Faker::Address.full_address)

    Shift.create(
        user_id: User.all.sample.id, 
        store_id: Store.all.sample.id, 
        start_time: DateTime.now + (rand * 30), 
        end_time: DateTime.now + (rand * 30))
end