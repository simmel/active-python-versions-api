requires 'Mojolicious', '>= 9.0, < 10.0';
requires 'IO::Socket::SSL';

on 'develop' => sub {
  recommends 'App::Prove';
};
