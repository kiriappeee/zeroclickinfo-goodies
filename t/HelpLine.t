#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use DDG::Test::Location;
use DDG::Request;

zci answer_type => 'helpline';
zci is_cached   => 0;

my @queries = (
    'suicide',
    'suicide hotline',
    'kill myself',
    'suicidal thoughts',
    'end my life',
    'suicidal thoughts',
    'suicidal',
    'suicidal ideation',
    'i want to kill myself',
    'commit suicide',
    'suicide pills',
    'suicide pill',
    'suicide prevention',
    'kill myself',
);

my @locations = (
    'au',
    'us',
);

my @ok_queries = (
    'suicide girls',
    'suicide silence',
);

sub build_structured_answer{
    my ($result, $operation) = @_;
    return "24 Hour Suicide Hotline $operation",
        structured_answer => {
            data => {
                title => "24 Hour Suicide Hotline $operation",
                record_data => $result,
            },
            templates => {
                group => "list",
                options => {
                    content => 'record',
                }
          }
        }
}

sub build_test{test_zci( build_structured_answer(@_))}

my @test_us = ({
        'National Suicide Prevention Lifeline' => "1-800-273-TALK (8255)"
    }, 'in the U.S.');
my @test_de = ({
        'Telefonseelsorge' => "0800 111 0 111 (or 222)"
    }, 'in Germany');

ddg_goodie_test(
    [qw(
	DDG::Goodie::HelpLine
    )],
    DDG::Request->new(
        query_raw => 'suicide',
        location => test_location('us'),
    ),
    build_test(@test_us),
     
    DDG::Request->new(
        query_raw => 'suicide',
        location => test_location('de'),
    ),
    build_test(@test_de),
    
    DDG::Request->new(
        query_raw => 'suicide silence',
        location => test_location('us'),
    ),
    undef
 );

done_testing;
