use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'SMS::Send::TW::PChome',
    VERSION_FROM      => 'lib/SMS/Send/TW/PChome.pm', # finds $VERSION
    PREREQ_PM         => {
            'SMS::Send'			=> 0.03,
            'Net::SMS::PChome'		=> 0.11,
    },
    ($] >= 5.006001 ?     ## Add these new keywords supported since 5.006001
      (ABSTRACT_FROM  => 'lib/SMS/Send/TW/PChome.pm', # retrieve abstract from module
       AUTHOR         => 'Tsung-Han Yeh <snowfly@yuntech.edu.tw>') : ()),
);
