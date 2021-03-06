use v6.c;
unit module App::VGMAudtionUI::GTK::PlayBar;
use App::VGMAudtionUI::GTK::Component;

our class PlayBar is export does App::VGMAudtionUI::GTK::Component {
    use GTK::Simple;
    use GTK::Simple::App;

    has GTK::Simple::Button $.skip-backward
        is built-with({ label => '<<'})
        is gridable([0, 0, 1, 1]);

    has GTK::Simple::Button $.step-backward
        is built-with({ label => '<'})
        is gridable([1, 0, 1, 1]);

    has GTK::Simple::Button $.play
        is built-with({ label => 'Play'})
        is gridable([2, 0, 1, 1]);

    has GTK::Simple::Button $.stop
        is built-with({ label => 'Stop'})
        is gridable([3, 0, 1, 1]);

    has GTK::Simple::Button $.step-forward
        is built-with({ label => '>'})
        is gridable([4, 0, 1, 1]);

    has GTK::Simple::Button $.skip-forward
        is built-with({ label => '>>'})
        is gridable([5, 0, 1, 1]);

    submethod TWEAK() {
        self.init
    }

    #! Override default empty event action method
    method clicked-event-action(Str $event --> Callable) {
        my $skip-event = self.event-prefixer.('skip');
        given $event {
            when 'step-forward' { -> { $skip-event, 1 } }
            when 'skip-forward' { -> { $skip-event, 100 } }
            when 'step-backward' { -> { $skip-event, -1 } }
            when 'skip-backward' { -> { $skip-event, -100 } }
            default { Callable }
        }
    }
}
