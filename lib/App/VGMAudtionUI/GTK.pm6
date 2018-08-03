use v6.c;

unit class App::VGMAudtionUI::GTK;
use GTK::Simple;
use GTK::Simple::App;
use App::VGMAudtionUI::GTK::PlayBar;

has GTK::Simple::App $!app;

has GTK::Simple::Button %!buttons;

method stop() {
    die "Application is not currently running!" unless $!app.so;
    $!app.exit;
}

method start() {
    die "Application has already been started!" if $!app.so;
    $!app .= new(title => "VGM content audition");

    # Configure app window
    # Add padding between content and the edge of the window
    $!app.border-width = 20;

    self!button('exit', %(label => 'Exit'))
        .clicked.tap({
            self.stop
        });

    $!app.set-content(
        GTK::Simple::VBox.new(
            |%!buttons.values,
            GTK::Simple::Grid.new(
                PlayBar.new.include-gridable
            )
        )
    );

    $!app.run;
}

method !button(Str $name, %properties --> GTK::Simple::Button) {
    die "Button $name already exists" if %!buttons{$name}:exists;
    my $button = GTK::Simple::Button.new(|%properties);
    %!buttons{$name} = $button;
    $button
}
