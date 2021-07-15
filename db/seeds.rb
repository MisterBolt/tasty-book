
puts "Seeding db: "

user = User.where(username: "John Doe").first_or_create \
  username:"John Doe", \
  email: "john.doe@example.com", \
  password: "password"

print "."

recipe = Recipe.where(title: "Apple Cake").first_or_create \
  title: "Apple Cake",
  description: "With chunks of sweet apples nestled in a tender and buttery rum cake, this apple cake is the essence of simplicity."

print "."

comment = Comment.where(body: "the best apple cake ever!").first_or_create \
  body: "the best apple cake ever!", \
  user: user, \
  recipe: recipe 

print "."

puts "\nDB seeded!" 