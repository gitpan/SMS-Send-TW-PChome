package SMS::Send::TW::PChome;

use strict;
use base 'SMS::Send::Driver';
use WWW::Mechanize;

use vars qw{$VERSION};
BEGIN {
   $VERSION = '0.02';
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
   my $baseurl = 'http://sms.pchome.com.tw/jsp/smslong.jsp';

   # Get the message and destination
   my $message   = $self->_MESSAGE( $params{text} );
   my $recipient = $self->_TO( delete $params{to} );
   
   my $ua = WWW::Mechanize->new(
      agent => __PACKAGE__." v. $VERSION",
   );

   $ua->agent_alias('Windows IE 6');
   
   # Should be ok now, right? Let's send it!
   # Login
   $ua->get($baseurl);
   $ua->form_number(1);
   $ua->field('smsid', $self->{"_username"});
   $ua->field('pwd', $self->{"_password"});
   $ua->submit();   
   
   # Input SMS_Message, Recipients
   $ua->form_number(2);
   $ua->field('InputMsg', $message);
   $ua->field('mobiles', $recipient);
   $ua->field('sendType', '1');
   $ua->field('longCount', '1');  # count of recipient
   $ua->submit();

   # Input Authcode	
   $ua->field('auth_code', $self->{"_authcode"});
   $ua->current_form()->action('https://ezpay.pchome.com.tw/auth_form_do');
   $ua->submit();
   
   return $ua->content;
}

sub _MESSAGE {

  my $class = ref $_[0] ? ref shift : shift;
  my $message = shift;
  unless ( length($message) <= 160 ) {
    Carp::croak("Message length limit is 160 characters");
  }
  
  return $message;
}

sub _TO {
  my $class = ref $_[0] ? ref shift : shift;
  my $to = shift;

  # International numbers need their + removed
  $to =~ y/0123456789//cd;

  return $to;
}
  

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

SMS::Send::TW::PChome - SMS::Send driver for sms.pchome.com.tw

=head1 SYNOPSIS

  use SMS::Send;

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
See L<WWW::Mechanize> for details on these parameters. 

=head2 send_sms

Takes C<to> as recipient phonenumber, and C<text> as the text that's
supposed to be delivered.


=head1 SEE ALSO

=over 5

=item * L<Send::SMS>

=item * L<WWW::Mechanize>

=back

=head1 BUGS

Please report any bugs to L<http://rt.cpan.org/Ticket/Create.html?Queue=Send-SMS-TW-PChome>


=head1 AUTHOR

Tsung-Han Yeh, E<lt>snowfly@yuntech.edu.twE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Tsung-Han Yeh

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
