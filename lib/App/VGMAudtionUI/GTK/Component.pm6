use v6.c;

unit role App::VGMAudtionUI::GTK::Component;

# storage for our component init builders
my @element-builder;

multi sub trait_mod:<is>(Attribute $p, :$built-with) is export {
    #= Define how to initialise this component.
    #= Either pass an Associative structure for constructing the GUI element
    #= or provide a function, accepting a self parameter which returns an Associative structure.
    given $built-with {
        when Callable {
            @element-builder.push: -> $self {
                $p.set_value: $self, $p.get_value($self).new(|$built-with($self))
            }
        }
        when Associative {
            @element-builder.push: -> $self {
                $p.set_value: $self, $p.get_value($self).new(|$built-with)
            }
        }
        default { die "built-with trait expected Callable or Associate but received { $built-with.WHAT.gist }" }
    }
}

# storage for gridable
my @element-gridable;
multi sub trait_mod:<is>(Attribute $p, :$gridable) is export {
    #= Define grid a UI element as being grid placeable.
    #= Requires a Positional structure of four Numeric values relating to
    #= x-position, y-position, x-size and y-size.

    # check arguments
    die "gridable trait expected 4 Numeric arguments received { $gridable.gist }" unless $gridable ~~ Positional and $gridable.grep( * ~~ Numeric).elems == 4;

    @element-gridable.push: $($gridable.List, $p)
}

method include-gridable( --> Slip) {
    #= Return a Slip of gridable UI elements.
    my $s = self;
    @element-gridable
        .map( -> ($quad, $attr) { $quad => $attr.get_value($s) } )
        .Slip
}

#! Initialises our component according to the given builder spec
method init() {
    for @element-builder -> $b {
        $b(self)
    }
}

#! Aggregate click event supplies of all attributes implementing a clicked method
method clicked( --> Supply) {
    my $s = self;
    my Supplier $aggregator .= new;
    my $event-prefixer = $s.event-prefixer;

    for $s.^attributes -> $attr {
        # Collect result of clicked on any attributes which implement the method.
        with $attr.get_value($s).?clicked -> $clicked {
            my $event-source = $attr.name.substr(2);
            my $event-name = $event-prefixer($event-source);
            with $s.clicked-event-action($event-source) -> $action {
                $clicked.tap({ $aggregator.emit: $action() })
            }
            else {
                $clicked.tap({ $aggregator.emit: $($event-name, ) })
            }
        }
    }

    $aggregator.Supply
}

#! Override to handle click events
method clicked-event-action(Str $command --> Callable) {
    # No action defined
    Callable
}

#! Default implementation of event prefixing
#! Returns the full class name by default.
method component-event-prefix( --> Str) {
    state $prefix = self.WHAT.^name;
    $prefix
}

# provides a closure to prefix event names
method event-prefixer( --> Callable) {
    my $prefix = self.component-event-prefix;
    sub event-prefixer(Str $event) { join '::', $prefix, $event }
}
