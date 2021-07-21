puts "Seeding db: "

user1 = User.where(username: "John Doe").first_or_create(
  username: "John Doe",
  email: "john.doe@example.com",
  password: "password"
)

print "."

cook_book = CookBook.where(user: user, favourite: true).first_or_create(
  user: user,
  title: "Favourites",
  visibility: :private,
  favourite: true
)

print "."

user2 = User.where(username: "Bruce Lee").first_or_create(
  username: "Bruce Lee",
  email: "bruce.lee@example.com",
  password: "password"
)

print "."

recipe1 = Recipe.where(title: "Apple Cake").first_or_create(
  title: "Apple Cake",
  description: "With chunks of sweet apples nestled in a tender and buttery rum cake, this apple cake is the essence of simplicity.",
  user: user1
)

print "."

recipe2 = Recipe.where(title: "Chicken Nuggets").first_or_create(
  title: "Chicken Nuggets",
  description: "Easy and a quick kids meal.",
  user: user2
)

print "."

Comment.where(body: "the best apple cake ever!").first_or_create(
  body: "the best apple cake ever!",
  user: user1,
  recipe: recipe1
)

print "."

Comment.where(body: "the best chicken nuggets ever!").first_or_create(
  body: "the best chicken nuggets ever!",
  user: user2,
  recipe: recipe2
)

print "."

Comment.where(body: "wow!").first_or_create(
  body: "wow!",
  user: user2,
  recipe: recipe1
)

print "."

Comment.where(body: "amazing!").first_or_create(
  body: "amazing!",
  user: user1,
  recipe: recipe2
)

print "."

comment = Comment.where(body: "the best apple cake ever!").first_or_create(
  body: "the best apple cake ever!",
  user: user,
  recipe: recipe
)

puts "\nDB seeded!"
