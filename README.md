# Recipebook 
[![Ruby](https://img.shields.io/badge/ruby-3.0.2-brightgreen.svg)](https://www.ruby-lang.org/en/news/2021/07/07/ruby-3-0-2-released/)
[![Rails](https://img.shields.io/badge/rails-6.1.4-brightgreen.svg)](https://rubygems.org/gems/rails/versions/6.1.4)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/testdouble/standard)


<!-- TABLE OF CONTENTS -->
## Table of Contents

* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
* [Development](#development)

<!-- GETTING STARTED -->
## Getting Started
To get a local copy up and running follow these simple example steps.

<!-- PREREQUISITES -->
### Prerequisites

- **Ruby & Postgresql**
  - https://www.ruby-lang.org/
  - https://www.postgresql.org/

<!-- INSTALLATION -->
### Installation

1. Clone the repo
```sh
git clone https://github.com/Ragnarson-recruitment/recipe-book
```
2. Install dependencies
```sh
bundle install
yarn install
```
3. Create DB
```sh
rails db:setup
```

<!-- DEVELOPMENT -->
## Development
List of usefull commands
1. Boot application
```sh
rails s
```
2. Manually run standard
```sh
 bundle exec standardrb
```
3. Run migrations
```sh
rails db:migrate
```



