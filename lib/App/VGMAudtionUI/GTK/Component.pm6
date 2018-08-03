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

#! Aggregate click event supplies
method aggregate-click-events( --> Supply) {
    my $s = self;
    my Supplier $aggregator .= new;

    for $s.^attributes -> $attr {
        with $attr.get_value($s).?clicked {
            .tap({ $aggregator.emit: $s.click-events($attr.name) })
        }
    }

    $aggregator.Supply
}

#! Override to handle click events
method click-events($command) {
    $command
}
