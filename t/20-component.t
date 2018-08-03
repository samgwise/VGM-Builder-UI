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
    has TestProp $.static   is built-with({ a => 'b' });
    has TestProp $.dynamic  is built-with( -> $self { %(a => $self.name ) });
    has TestProp $.gridable
        is built-with({ a => 'c' })
        is gridable([1, 1, 6, 4]);
}

my TestComponent $test .= new: :name<testing>;

$test.init;

is $test.static.a,  'b',        "Static built-with";
is $test.dynamic.a, $test.name, "Dynamic built-with";

is $test.include-gridable, ([1, 1, 6, 4] => $test.gridable), "Include gridable";

done-testing;
