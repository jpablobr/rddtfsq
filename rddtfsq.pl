#!/usr/bin/env perl
#--------------------------
# Author: José Pablo Barrantes R. <xjpablobrx@gmail.com>
# Created: 12 Mar 2011
# Version: 0.1.0

use Mojolicious::Lite;
use constant SOLR => 'http://127.0.0.1:8983/solr';

# Search form
get '/' => 'index';

# Search result
get '/search' => sub {
	my $self = shift;

	my $solr = SOLR . '/select';

	# Prepare the query
	my $search = {
		q => $self->param('q') ? $self->param('q') : '[* TO *]', # show all
		wt => 'json',
		rows => $self->param('rows') ? $self->param('rows') : '5',
		start => $self->param('start') ? $self->param('start') : '0',
		fl => $self->param('fl') ? $self->param('fl') : '*'
	};
	my $tx = $self->client->post_form($solr => $search);

	# Search result
	if (my $res = $tx->success) {
		$self->render( result => $res->json )
	} else {
		my ($message, $code) = $tx->error;
		return $self->render(template => 'error', message => $message);
	}

	# Handle errors
	my $error = undef;
	return $self->render(template => 'error', message => $error)
		if $error;
} => 'search';

app->secret('solr234');

app->start;

__DATA__

@@ layouts/default.html.ep
<!doctype html><html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" >
	<title>Recursive directory data traverser for solr querying (rddtfsq)</title>

	<style type="text/css">/*<![CDATA[*/
	body {
		background-color: #f5f6f8;
		color: #333;
		font: 0.9em Verdana, sans-serif;
		margin-left: 5em;
		margin-right: 5em;
		margin-top: 0;
	}
	hr {
		color: #666;
		background-color: #666;
		height: 1px;
		border: 0;
	}
	#result {
		background:#ffffff;
	}
	#row {
		margin:10px;
	}
	#footer {
		margin-top: 1.5em;
		text-align: center;
	}
	/*]]>*/</style>

</head>
<body>
	<h2>A simple Solr directories data indexer</h2>
	<%= content %>
	<br/>
	<div id="footer">
		<hr/>
		By <a href="http://jpablobr.com">Jose Pablo Barrantes</a> and <a href="http://mojolicio.us">Mojolicious</a>
	</div>
</body>
</html>


@@ index.html.ep
% layout 'default';
<%= include 'search_form' %>

@@ search_form.html.ep
<form method="get" action="<%= url_for('search') %>">
	<div>
		<input type="text" name="q" value="readme"/>
		<input type="submit" value="Search" />
	</div>
</form>

@@ error.html.ep
% layout 'default';
<%= include 'search_form' %>
<%= $message %>

@@ search.html.ep
% layout 'default';
<%= include 'search_form' %>
<br/>

%# Parse JSON elements
% my $query = $result->{'responseHeader'}->{'params'}->{'q'};
% my $rows  = $result->{'responseHeader'}->{'params'}->{'rows'};
% my $hits  = $result->{'response'}->{'numFound'};
% my $start = $result->{'response'}->{'start'};
% my $docs  = $result->{'response'}->{'docs'};
% my $max   = $start + $rows;
% $max      = $hits if $max > $hits;

<div style="display:inline;float:left;width: 45%;">
	Showing <%= $start %> to <%= $max %> of <%= $hits %>
	for <b><%== $query %></b>
</div>

<div style="float:right;text-align:right;width: 45%;">
% if ( $start > 0 ) {
<a href="<%= url_for('search') %>?q=<%= $query %>
	&start=<%= $start - $rows %>
	&rows=<%= $rows %>">previous</a>
% }
% if ( $max < $hits ) {
&nbsp;
<a href="<%= url_for('search') %>?q=<%= $query %>
	&start=<%= $max %>
	&rows=<%= $rows %>">next</a>
% }
</div>

<br/>

<div id="result">
% foreach my $item (@{$docs}) {
	<div id="doc">
	<hr>
% 	foreach my $key (keys %{$item}) {
		<div id="row">
			<b><%= $key %>: </b>
%		if ( ref $item->{$key} eq 'ARRAY' ) {
			<%== join ('; ', @{ $item->{$key} }) %>
%		} else {
			<%= $item->{$key} %>
%		}
		</div>
%	}
	<div>
% }
</div>
