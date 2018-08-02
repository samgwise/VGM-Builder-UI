#! /usr/bin/env perl6
use v6.c;
use App::VGMAudtionUI::GTK;

sub MAIN() {
    my $app = App::VGMAudtionUI::GTK.new;
    $app.start;
}
