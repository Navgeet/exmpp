% $Id$

-module(check_stream).
-vsn('$Revision$').

-include("exmpp.hrl").

-export([check/0, do_check/0]).

check() ->
    do_check(),
    testsuite:pass().

do_check() ->
    test_stream_opening(),
    test_stream_opening_reply(),
    test_stream_closing(),
    ok.

% --------------------------------------------------------------------
% Stream handling testsuite.
% --------------------------------------------------------------------

-define(OPENING1,
  {xmlnselement, ?NS_XMPP, "stream", ?NS_JABBER_CLIENT, 'stream', [
      {xmlattr, undefined, undefined, 'to', "dest"}
    ], undefined}
).

-define(OPENING2,
  {xmlnselement, ?NS_XMPP, "stream", ?NS_JABBER_CLIENT, 'stream', [
      {xmlattr, undefined, undefined, 'to', "dest"},
      {xmlattr, undefined, undefined, 'version', "1.0"}
    ], undefined}
).

-define(OPENING3,
  {xmlnselement, ?NS_XMPP, "stream", ?NS_JABBER_CLIENT, 'stream', [
      {xmlattr, undefined, undefined, 'to', "dest"},
      {xmlattr, undefined, undefined, 'version', "1.0"},
      {xmlattr, ?NS_XML, undefined, 'lang', "fr"}
    ], undefined}
).

-define(OPENING_REPLY1,
  {xmlnselement, ?NS_XMPP, "stream", ?NS_JABBER_CLIENT, 'stream', [
      {xmlattr, undefined, undefined, 'from', "dest"},
      {xmlattr, undefined, undefined, 'id', "foobar"}
    ], undefined}
).

-define(OPENING_REPLY2,
  {xmlnselement, ?NS_XMPP, "stream", ?NS_JABBER_CLIENT, 'stream', [
      {xmlattr, undefined, undefined, 'from', "dest"},
      {xmlattr, undefined, undefined, 'version', "1.0"},
      {xmlattr, undefined, undefined, 'id', "foobar"}
    ], undefined}
).

-define(OPENING_REPLY3,
  {xmlnselement, ?NS_XMPP, "stream", ?NS_JABBER_CLIENT, 'stream', [
      {xmlattr, undefined, undefined, 'from', "dest"},
      {xmlattr, undefined, undefined, 'version', "1.0"},
      {xmlattr, undefined, undefined, 'id', "foobar"},
      {xmlattr, ?NS_XML, undefined, 'lang', "fr"}
    ], undefined}
).

-define(OPENING_REPLY1a,
  {xmlnselement, ?NS_XMPP, "stream", ?NS_JABBER_CLIENT, 'stream', [
      {xmlattr, undefined, undefined, 'from', "dest"},
      {xmlattr, undefined, undefined, 'id', "foobar"}
    ], undefined}
).

-define(OPENING_REPLY2a,
  {xmlnselement, ?NS_XMPP, "stream", ?NS_JABBER_CLIENT, 'stream', [
      {xmlattr, undefined, undefined, 'version', "1.0"},
      {xmlattr, undefined, undefined, 'from', "dest"},
      {xmlattr, undefined, undefined, 'id', "foobar"}
    ], undefined}
).

-define(OPENING_REPLY3a,
  {xmlnselement, ?NS_XMPP, "stream", ?NS_JABBER_CLIENT, 'stream', [
      {xmlattr, undefined, undefined, 'version', "1.0"},
      {xmlattr, ?NS_XML, undefined, 'lang', "fr"},
      {xmlattr, undefined, undefined, 'from', "dest"},
      {xmlattr, undefined, undefined, 'id', "foobar"}
    ], undefined}
).

-define(CLOSING1,
  {xmlnsendelement, ?NS_XMPP, "stream", 'stream'}
).

test_stream_opening() ->
    testsuite:is(exmpp_stream:opening("dest", ?NS_JABBER_CLIENT, undefined),
      ?OPENING1),
    testsuite:is(exmpp_stream:opening("dest", ?NS_JABBER_CLIENT, ""),
      ?OPENING1),
    testsuite:is(exmpp_stream:opening("dest", ?NS_JABBER_CLIENT, {0, 0}),
      ?OPENING1),
    testsuite:is(exmpp_stream:opening("dest", ?NS_JABBER_CLIENT, "1.0"),
      ?OPENING2),
    testsuite:is(exmpp_stream:opening("dest", ?NS_JABBER_CLIENT, {1, 0}),
      ?OPENING2),
    testsuite:is(exmpp_stream:opening("dest", ?NS_JABBER_CLIENT, "1.0", "fr"),
      ?OPENING3),
    ok.

test_stream_opening_reply() ->
    testsuite:is(exmpp_stream:opening_reply(
        "dest", ?NS_JABBER_CLIENT, undefined, "foobar"),
      ?OPENING_REPLY1),
    testsuite:is(exmpp_stream:opening_reply(
        "dest", ?NS_JABBER_CLIENT, "", "foobar"),
      ?OPENING_REPLY1),
    testsuite:is(exmpp_stream:opening_reply(
        "dest", ?NS_JABBER_CLIENT, {0, 0}, "foobar"),
      ?OPENING_REPLY1),
    testsuite:is(exmpp_stream:opening_reply(
        "dest", ?NS_JABBER_CLIENT, "1.0", "foobar"),
      ?OPENING_REPLY2),
    testsuite:is(exmpp_stream:opening_reply(
        "dest", ?NS_JABBER_CLIENT, {1, 0}, "foobar"),
      ?OPENING_REPLY2),
    testsuite:is(exmpp_stream:opening_reply(
        "dest", ?NS_JABBER_CLIENT, "1.0", "foobar", "fr"),
      ?OPENING_REPLY3),
    testsuite:is(exmpp_stream:opening_reply(?OPENING1, "foobar"),
      ?OPENING_REPLY1a),
    testsuite:is(exmpp_stream:opening_reply(?OPENING2, "foobar"),
      ?OPENING_REPLY2a),
    testsuite:is(exmpp_stream:opening_reply(?OPENING3, "foobar"),
      ?OPENING_REPLY3a),
    ok.

test_stream_closing() ->
    testsuite:is(exmpp_stream:closing(),
      ?CLOSING1),
    testsuite:is(exmpp_stream:closing(?OPENING1),
      ?CLOSING1),
    ok.