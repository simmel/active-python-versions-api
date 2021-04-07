#!/usr/bin/env perl
use Mojolicious::Lite -signatures;

under '/v1';

get '/' => {text => "I 🐍 Python!\n"};

app->start;
