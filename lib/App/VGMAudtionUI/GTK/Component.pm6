use v6.c;

unit role App::VGMAudtionUI::GTK::Component;

my @element-builder;
multi sub trait_mod:<is>(Attribute $p, :$built-with) is export {
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

#! Initialises our component according to the given builder spec
method init() {
    for @element-builder -> $b {
        $b(self)
    }
}
