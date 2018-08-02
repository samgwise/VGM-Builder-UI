#! /usr/bin/env perl6
use v6.c;
use Test;

use-ok 'App::VGMAudtionUI::GTK::Component';
use App::VGMAudtionUI::GTK::Component;

class TestProp {
    has Str $.a;
}

class TestComponent does App::VGMAudtionUI::GTK::Component {
    has Str $.name;
    has TestProp $.static is built-with({ a => 'b' });
    has TestProp $.lazy   is built-with( -> $self { %(a => $self.name ) });
}

my TestComponent $test .= new: :name<testing>;

$test.init;

is $test.static.a,  'b',        "Static built-with";
is $test.lazy.a,    $test.name, "Lazy built-with";

done-testing;
