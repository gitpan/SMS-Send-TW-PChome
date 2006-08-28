package SMS::Send::TW::PChome;

use strict;
use base 'SMS::Send::Driver';
use Net::SMS::PChome;

use vars qw{$VERSION};
BEGIN {
   $VERSION = '0.01';
}

sub new {
   my ($class, %params) = @_;

   foreach(qw/username password authcode/) {
      Carp::croak("No $_ specified") unless(defined $params{"_$_"});
   }

   my $self = bless { %params }, $class;

   return $self;
}

sub send_sms {
   my $self   = shift;
   my %params = @_;

   my $sms = Net::SMS::PChome->new(
      username  => $self->{"_username"},
      password  => $self->{"_password"},
      authcode  => $self->{"_authcode"},
   );

   $sms->smsRecipient($params{"to"});
   return $sms->smsSend($params{"text"});
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

SMS::Send::TW::PChome - SMS::Send driver for sms.pchome.com.tw

=head1 SYNOPSIS

  use SMS::Send::TW::PChome;

  my $sender = SMS::Send->new('TW::PChome',
                  _username   => 'UserName',
                  _password   => 'Password',
                  _authcode   => 'AuthCode',
                );

  my $sent = $sender->send_sms(
                  text => 'My very urgent message',
                  to   => '0912345678',
             );

=head1 DESCRIPTION

SMS::Send::TW::PChome is a SMS::Send driver which allows you to send messages through L<http://sms.pchome.com.tw/>.

=head1 METHODS

=head2 new

The C<new> method takes a few parameters. C<_username> , C<_password> , and C<_authcode>
are mandatory. 
See L<Net::SMS::PChome> for details on these parameters. 

This driver is a very simplified wrapper around L<Net::SMS::PChome> 
and provides a lot less functionality than L<Net::SMS::PChome>.

=head2 send_sms

Takes C<to> as recipient phonenumber, and C<text> as the text that's
supposed to be delivered.


=head1 SEE ALSO

=over 5

=item * L<Send::SMS>

=item * L<Net::SMS::PChome>

=back

=head1 BUGS

Please report any bugs to L<http://rt.cpan.org/Ticket/Create.html?Queue=Send-SMS-TW-PChome>


=head1 AUTHOR

Tsung-Han Yeh, E<lt>snowfly@yuntech.edu.twE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Tsung-Han Yeh

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
