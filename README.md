# LucidGen

LucidGen is a project generator for [Lucid](https://github.com/jnyman/lucid) test repositories.

## Installation

Install the gem as normal:

    $ gem install lucid-gen

## Usage

The easiest way to use Venom would be to have it generate the default structure for you:

    $ lucid-gen project project-spec

This command will create a project structure with the directory name as project-spec.

The default driver for the projects created is [Fluent](https://github.com/jnyman/fluent). You can change this by specifying a driver

    $ lucid-gen project project-spec --driver=capybara

Do note that, for the moment, LucidGen only generates driver files relevant to Fluent.

## Contributing

1. [Fork the project](http://gun.io/blog/how-to-github-fork-branch-and-pull-request/).
2. Create a feature branch. (`git checkout -b my-new-feature`)
3. Commit your changes. (`git commit -am 'new feature'`)
4. Push the branch. (`git push origin my-new-feature`)
5. Create a new [pull request](https://help.github.com/articles/using-pull-requests).
