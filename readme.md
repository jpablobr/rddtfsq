# Recursive directory data traverser for solr querying (rddtfsq)

## Dependencies

Perl:

  * XML::Writer
  * Tie::File
  * File::Find

Solr:

You need to know about Solr, but if you don't [here is how to get started](http://lucene.apache.org/solr/tutorial.html).

It is also vendored in the app (The Solr directory).

## Installation

After installing [Mojo](https://github.com/kraih/mojo).

      $ git clone git://github.com/jpablobr/rddtfsq.git

      $ cd rddtfsq

      $ ./servers_starter.pl

Then you need to define the path to your data in the `data_dump.pl` file using the `$data_path` variable. After that, you can index the data in Solr doing the following:

      $ ./data_dump.pl

This might take a while depending on your amount data.

Go to [localhost:3000](http://localhost:3000) with your trusty brower, and be amazed! You’re done... SRSLY!

## TODO:

   * Single page view for single results.
   * Search should be more user friendly.

## Note on Patches/Pull Requests:

Fork the project. Make your feature addition or bug fix. Send me a pull request. Bonus points for topic branches.

## Copyright:

(The MIT License)

Copyright 2011 Jose Pablo Barrantes. MIT Licence, so go for it.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, an d/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
