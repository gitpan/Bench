#!perl -T

use strict;
use warnings;

use Test::More tests => 6;
use Module::Loaded;
use Bench;

like(bench(sub {}), qr!100 calls.+0\.\d+s.+0\.\d+ms/call!,
     "bench single sub with default opts");
like(bench(sub {}, 2), qr!2 calls!,
     "bench single sub with opts: 2");
like(bench(sub {}, {n=>0}), qr!1 calls!,
     "bench single sub with opts: {n=>0}");
like(bench({a=>sub {}, b=>sub {}}, {n=>0}), qr!^a:.+^b:!ms,
     "bench multiple subs (hash)");
like(bench([sub {}, sub {}], {n=>0}), qr!^a:.+^b:!msx,
     "bench multiple subs (array)");

SKIP: {
    # XXX use Capture::Tiny
    eval { require Dumbbench };
    skip "Can't load Dumbbench", 1 unless is_loaded("Dumbbench");
    like(bench(sub {}, {dumbbench=>1}), qr!^$!,
         "bench single sub with opts: {dumbbench=>1}");
}
