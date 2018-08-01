# Paraspec

Paraspec is a parallel RSpec test runner.

It is built with a producer/consumer architecture. A master process loads
the entire test suite and sets up a queue to feed the tests to the workers.
Each worker requests a test from the master, runs it, reports the results
back to the master and requests the next test until there are no more left.

This producer/consumer architecture enables a number of features:

1. The worker load is naturally balanced. If a worker happens to come across
a slow test, the other workers keep chugging away at faster tests.
2. Tests defined in a single file can be executed by multiple workers,
since paraspec operates on a test by test basis and not on a file by file basis.
3. Standard output and error streams can be[*] captured and grouped on a
test by test basis, avoiding interleaving output of different tests together.
This output capture can be performed for output generated by C extensions
as well as plain Ruby code.
4. Test results are seamlessly integrated by the master, such that
a parallel run produces a single progress bar with Fuubar across all workers.

[*] This feature is not yet implemented.

## Usage

For a test suite with no external dependencies, using paraspec is
trivially easy. Just run:

    paraspec

To specify concurrency manually:

    paraspec -c 4

To pass options to rspec, for example to filter examples to run:

    paraspec -- -e 'My test'
    paraspec -- spec/my_spec.rb

## Advanced Usage

### Formatters

Paraspec works with any RSpec formatter, and supports multiple formatters
just like RSpec does. If your test suite is big enough for parallel execution
to make a difference, chances are the default progress and documentation
formatters aren't too useful for dealing with its output.

I recommend [Fuubar](https://github.com/thekompanee/fuubar) and
[RSpec JUnit Formatter](https://github.com/sj26/rspec_junit_formatter)
configured at the same time. Fuubar produces a very nice looking progress bar
plus it prints failures and exceptions to the terminal as soon as they
occur. JUnit output, passed through a JUnit XML to HTML converter like
[junit2html](https://gitlab.com/inorton/junit2html), is much handier
than going through terminal output when a run produces 100 or 1000
failing tests.

## Bugs & Patches

## License

MIT
