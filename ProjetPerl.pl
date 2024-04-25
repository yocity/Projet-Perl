use strict;
use warnings;
use File::Tail;
use GD::Graph::bars;
use GD::Graph::Data;

my $access_log_file = 'access.log';

my $error_log_file = 'error.log';

my $access_tail = File::Tail->new(name => $access_log_file, maxinterval => 1);

my $error_tail = File::Tail->new(name => $error_log_file, maxinterval => 1);

my %access_count;
my %error_count;
my $successful_requests = 0;
my $failed_requests = 0;

sub print_results {
    system("cls");
    print "Résultats de l'analyse du fichier de log d'accès Apache :\n";
    print "--------------------------------------------------------\n";
    print "Nombre de requêtes réussies : $successful_requests\n";
    print "Nombre de requêtes échouées : $failed_requests\n\n";

    print "Adresses IP les plus actives :\n";
    print "-------------------------------\n";
    foreach my $ip (sort { $access_count{$b} <=> $access_count{$a} } keys %access_count) {
        my $count = $access_count{$ip};
        print "$ip : $count\n";
    }

    print "\nMessages d'erreur :\n";
    print "---------------------------------------\n";
    foreach my $error_message (sort { $error_count{$b} <=> $error_count{$a} } keys %error_count) {
        my $count = $error_count{$error_message};
        print "$error_message : $count\n";
    }

    my @ip_data;
    foreach my $ip (sort { $access_count{$b} <=> $access_count{$a} } keys %access_count) {
        my $count = $access_count{$ip};
        push @ip_data, [$ip, $count];
    }
    create_bar_graph("Adresses IP les plus actives", \@ip_data, "ip_graph.png");

    my @error_data;
    foreach my $error_message (sort { $error_count{$b} <=> $error_count{$a} } keys %error_count) {
        my $count = $error_count{$error_message};
        push @error_data, [$error_message, $count];
    }
    create_bar_graph("Messages d'erreur les plus fréquents", \@error_data, "error_graph.png");
}

sub create_bar_graph {
    my ($title, $data_ref, $output_file) = @_;

    my $graph = GD::Graph::bars->new(800, 600);

    $graph->set(
        x_label         => 'Élément',
        y_label         => 'Fréquence',
        title           => $title,
        bar_spacing     => 5,
        shadow_depth    => 4,
        shadowclr       => 'dred',
        transparent     => 0,
        fgclr           => 'black',
        dclrs           => [ qw(lred lblue lgreen lyellow) ],
    );

    my $data = GD::Graph::Data->new($data_ref) or die GD::Graph::Data->error;
    $graph->plot($data) or die $graph->error;

    open(my $img_file, '>', $output_file) or die "Cannot open file $output_file: $!";
    binmode $img_file;
    print $img_file $graph->gd->png;
    close $img_file;
}

while (1) {

    if (defined(my $access_line = $access_tail->read)) {
        chomp $access_line;
        my ($ip) = $access_line =~ /^(\S+)/;
        $access_count{$ip}++;
    }

    if (defined(my $error_line = $error_tail->read)) {
        chomp $error_line;
        if ($error_line =~ /\[.*?\] \[.*?\] \[.*?\] (\[.*?\] )?(\[.*?\] )?(.*)/) {
            my $error_message = $3;
            $error_message =~ s/\[.*?\] //g;

            if ($error_line =~ / AH00455: Apache/) {
                $successful_requests++;
            } elsif ($error_line =~ / AH00456: Apache/) {
                $failed_requests++;
            }
            $error_count{$error_message}++;
        }
    }

    print_results();
    sleep(1);
    
if (my @ip_data && my @error_data) {
    create_bar_graph("Adresses IP les plus actives", \@ip_data, "ip_graph.png");
    create_bar_graph("Messages d'erreur les plus fréquents", \@error_data, "error_graph.png");
} else {
    print "Aucune donnée disponible pour créer les graphiques.\n";
}
}
