# bird::bgp
#
# This defined resource manages the bgp neighbor configuration
#
# @summary Manages the bgp protocol or template configuration
#
# @api private
#
# @example
#   bird::bgp { 'namevar': }
#
# @param
#   add_paths
#     Standard BGP can propagate only one path (route) per destination network
#     (usually the selected one). This option controls the add-path protocol
#     extension, which allows to advertise any number of paths to a destination.
#     Note that to be active, add-path has to be enabled on both sides of the
#     BGP session, but it could be enabled separately for RX and TX direction.
#     When active, all available routes accepted by the export filter are
#     advertised to the neighbor. Default: false.
#
# @param
#   advertise_ipv4
#     Advertise IPv4 multiprotocol capability. This is not a correct behavior
#     according to the strict interpretation of RFC 4760, but it is widespread
#     and required by some BGP implementations (Cisco and Quagga). This option
#     is relevant to IPv4 mode with enabled capability advertisement only.
#     Default: true.
#
# @param
#   allow_local_as
#     BGP prevents routing loops by rejecting received routes with the local AS
#     number in the AS path. This option allows to loose or disable the check.
#     Optional number argument can be used to specify the maximum number of
#     local ASNs in the AS path that is allowed for received routes. When the
#     option is used without the argument, the check is completely disabled and
#     you should ensure loop-free behavior by some other means. Default: 0 (no
#     local AS number allowed).
#
# @param
#   as4
#     BGP protocol was designed to use 2B AS numbers and was extended later to
#     allow 4B AS number. BIRD supports 4B AS extension, but by disabling this
#     option it can be persuaded not to advertise it and to maintain old-style
#     sessions with its neighbors. This might be useful for circumventing bugs
#     in neighbor's implementation of 4B AS extension. Even when disabled (off),
#     BIRD behaves internally as AS4-aware BGP router. Default: true.
#
# @param
#   bfd
#     BGP could use BFD protocol as an advisory mechanism for neighbor liveness
#     and failure detection. If enabled, BIRD setups a BFD session for the BGP
#     neighbor and tracks its liveness by it. This has an advantage of an order
#     of magnitude lower detection times in case of failure. Note that BFD
#     protocol also has to be configured, see BFD section for details.
#     Default: false.
#
# @param
#   capabilities
#     Use capability advertisement to advertise optional capabilities. This is
#     standard behavior for newer BGP implementations, but there might be some
#     older BGP implementations that reject such connection attempts. When
#     disabled (false), features that request it (4B AS support) are also
#     disabled. Default: true, with automatic fallback to off when received
#     capability-related error.
#
# @param
#   check_link
#     BGP could use hardware link state into consideration. If enabled, BIRD
#     tracks the link state of the associated interface and when link
#     disappears (e.g. an ethernet cable is unplugged), the BGP session is
#     immediately shut down. Note that this option cannot be used with multihop
#     BGP. Default: false.
#
# @param
#   conf_path
#     Specifies the configuration file. Default: '/etc/bird.conf'
#
# @param
#   connect_retry_time
#     Time in seconds to wait before retrying a failed attempt to connect.
#     Default: 120 seconds.
#
# @param
#   connect_delay_time
#     Delay in seconds between protocol startup and the first attempt to
#     connect. Default: 5 seconds.
#
# @param
#   default_bgp_local_pref
#     A default value for the Local Preference attribute. It is used when a new
#     Local Preference attribute is attached to a route by the BGP protocol
#     itself (for example, if a route is received through eBGP and therefore
#     does not have such attribute). Default: 100 (0 in pre-1.2.0 versions of
#     BIRD).
#
# @param
#   default_bgp_med
#     Value of the Multiple Exit Discriminator to be used during route
#     selection when the MED attribute is missing. Default: 0.
#
# @param
#   deterministic_med
#     BGP route selection algorithm is often viewed as a comparison between
#     individual routes (e.g. if a new route appears and is better than the
#     current best one, it is chosen as the new best one). But the proper route
#     selection, as specified by RFC 4271, cannot be fully implemented in that
#     way. The problem is mainly in handling the MED attribute. BIRD, by
#     default, uses an simplification based on individual route comparison,
#     which in some cases may lead to temporally dependent behavior (i.e. the
#     selection is dependent on the order in which routes appeared). This
#     option enables a different (and slower) algorithm implementing proper RFC
#     4271 route selection, which is deterministic. Alternative way how to get
#     deterministic behavior is to use med metric option. This option is
#     incompatible with sorted tables. Default: false.
#
# @param
#   disable_after_error
#     When an error is encountered (either locally or by the other side),
#     disable the instance automatically and wait for an administrator to fix
#     the problem manually. Default: false.
#
# @param
#   error_forget_time
#     Maximum time in seconds between two protocol failures to treat them as a
#     error sequence which makes error wait time increase exponentially.
#     Default: 300 seconds.
#
# @param
#   error_wait_time
#     Minimum and maximum delay in seconds between a protocol failure (either
#     local or reported by the peer) and automatic restart. Doesn't apply when
#     disable after error is configured. If consecutive errors happen, the
#     delay is increased exponentially until it reaches the maximum. Default:
#     60, 300.
#
# @param
#   export_filter
#     Specify a filter to be used for filtering routes coming from the routing
#     table to the protocol. all is shorthand for where true and none is
#     shorthand for where false. Default: 'none'.
#
# @param
#   extended_messages
#     The BGP protocol uses maximum message length of 4096 bytes. This option
#     provides an extension to allow extended messages with length up to 65535
#     bytes. Default: false.
#
# @param
#   gateway
#     For received routes, their gw (immediate next hop) attribute is computed
#     from received bgp_next_hop attribute. This option specifies how it is
#     computed. Direct mode means that the IP address from bgp_next_hop is
#     used if it is directly reachable, otherwise the neighbor IP address is
#     used. Recursive mode means that the gateway is computed by an IGP routing
#     table lookup for the IP address from bgp_next_hop. Note that there is
#     just one level of indirection in recursive mode - the route obtained by
#     the lookup must not be recursive itself, to prevent mutually recursive
#     routes.
#     Recursive mode is the behavior specified by the BGP standard. Direct mode
#     is simpler, does not require any routes in a routing table, and was used
#     in older versions of BIRD, but does not handle well nontrivial iBGP
#     setups and multihop. Recursive mode is incompatible with sorted tables.
#     Default: 'direct' for direct sessions, 'recursive' for multihop sessions.
#
# @param
#   graceful_restart
#     When a BGP speaker restarts or crashes, neighbors will discard all
#     received paths from the speaker, which disrupts packet forwarding even
#     when the forwarding plane of the speaker remains intact. RFC 4724
#     specifies an optional graceful restart mechanism to alleviate this issue.
#     This option controls the mechanism. It has three states: Disabled, when
#     no support is provided. Aware, when the graceful restart support is
#     announced and the support for restarting neighbors is provided, but no
#     local graceful restart is allowed (i.e. receiving-only role). Enabled,
#     when the full graceful restart support is provided (i.e. both restarting
#     and receiving role). Note that proper support for local graceful restart
#     requires also configuration of other protocols. Default: aware.
#
# @param
#   graceful_restart_time
#     The restart time is announced in the BGP graceful restart capability and
#     specifies how long the neighbor would wait for the BGP session to
#     re-establish after a restart before deleting stale routes. Default: 120
#     seconds.
#
# @param
#   hold_time
#     Time in seconds to wait for a Keepalive message from the other side
#     before considering the connection stale. Default: depends on agreement
#     with the neighboring router, we prefer 240 seconds if the other side is
#     willing to accept it.
#
# @param
#   igp_metric
#     Enable comparison of internal distances to boundary routers during best
#     route selection. Default: true.
#
# @param
#   import_filter
#     Specify a filter to be used for filtering routes coming from the protocol
#     to the routing table. all is shorthand for where true and none is
#     shorthand for where false. Default: 'all'.
#
# @param
#   interpret_communities
#     RFC 1997 demands that BGP speaker should process well-known communities
#     like no-export (65535, 65281) or no-advertise (65535, 65282). For example,
#     received route carrying a no-adverise community should not be advertised
#     to any of its neighbors. If this option is enabled (which is by default),
#     BIRD has such behavior automatically (it is evaluated when a route is
#     exported to the BGP protocol just before the export filter). Otherwise,
#     this integrated processing of well-known communities is disabled. In that
#     case, similar behavior can be implemented in the export filter. Default:
#     true.
#
# @param
#   keepalive_time
#     Delay in seconds between sending of two consecutive Keepalive messages.
#     Default: One third of the hold time.
#
# @param
#   local_as
#     Define which AS we are part of.
#
# @param
#   med_metric
#     Enable comparison of MED attributes (during best route selection) even
#     between routes received from different ASes. This may be useful if all
#     MED attributes contain some consistent metric, perhaps enforced in import
#     filters of AS boundary routers. If this option is disabled, MED
#     attributes are compared only if routes are received from the same AS
#     (which is the standard behavior). Default: false.
#
# @param
#   multihop
#     Specify that the neighbor is directly connected. The IP address of the
#     neighbor must be from a directly reachable IP range (i.e. associated with
#     one of your router's interfaces), otherwise the BGP session wouldn't start
#     but it would wait for such interface to appear. The alternative is the
#     multihop option. Default: true for eBGP.
#
# @param
#   next_hop_keep
#     Forward the received Next Hop attribute even in situations where the
#     local address should be used instead, like when the route is sent to an
#     interface with a different subnet. Default: false.
#
# @param
#   next_hop_self
#     Avoid calculation of the Next Hop attribute and always advertise our own
#     source address as a next hop. This needs to be used only occasionally to
#     circumvent misconfigurations of other routers. Default: false.
#
# @param
#   passive
#     Standard BGP behavior is both initiating outgoing connections and
#     accepting incoming connections. In passive mode, outgoing connections are
#     not initiated. Default: false.
#
# @param
#   password
#     Use this password for MD5 authentication of BGP sessions (RFC 2385). When
#     used on BSD systems, see also setkey option below.
#
# @param
#   path_metric
#     Enable comparison of path lengths when deciding which BGP route is the
#     best one. Default: true.
#
# @param
#   prefer_older
#     Standard route selection algorithm breaks ties by comparing router IDs.
#     This changes the behavior to prefer older routes (when both are external
#     and from different peer). For details, see RFC 5004. Default: false.
#
# @param
#   remote_as
#     Define what AS a neighboring router is located in.
#
# @param
#   remote_ip
#     Define neighboring router this instance will be talking to.
#
# @param
#   remote_port
#     Specifies the remote port.
#
# @param
#   route_limit
#     The maximal number of routes that may be imported from the protocol.
#     If the route limit is exceeded, the connection is closed with an error.
#     Limit is currently implemented as import limit number action restart.
#     This option is obsolete and it is replaced by import limit option.
#     Default: no limit.
#
# @param
#   route_refresh
#     After the initial route exchange, BGP protocol uses incremental updates
#     to keep BGP speakers synchronized. Sometimes (e.g., if BGP speaker
#     changes its import filter, or if there is suspicion of inconsistency) it
#     is necessary to do a new complete route exchange. BGP protocol extension
#     Route Refresh (RFC 2918) allows BGP speaker to request re-advertisement
#     of all routes from its neighbor. BGP protocol extension Enhanced Route
#     Refresh (RFC 7313) specifies explicit begin and end for such exchanges,
#     therefore the receiver can remove stale routes that were not advertised
#     during the exchange. This option specifies whether BIRD advertises these
#     capabilities and supports related procedures. Note that even when
#     disabled, BIRD can send route refresh requests. Default: true.
#
# @param
#   rr_client
#     Be a route reflector and treat the neighbor as a route reflection client.
#     Default: false.
#
# @param
#   rr_cluster_id
#     Route reflectors use cluster id to avoid route reflection loops. When
#     there is one route reflector in a cluster it usually uses its router id
#     as a cluster id, but when there are more route reflectors in a cluster,
#     these need to be configured (using this option) to use a common cluster
#     id. Clients in a cluster need not know their cluster id and this option
#     is not allowed for them. Default: the same as router id.
#
# @param
#   rs_client
#     Be a route server and treat the neighbor as a route server client.
#     A route server is used as a replacement for full mesh EBGP routing in
#     Internet exchange points in a similar way to route reflectors used in
#     IBGP routing. BIRD does not implement obsoleted RFC 1863, but uses ad-hoc
#     implementation, which behaves like plain EBGP but reduces modifications
#     to advertised route attributes to be transparent (for example does not
#     prepend its AS number to AS PATH attribute and keeps MED attribute).
#     Default: false.
#
# @param
#   secondary
#     Usually, if an export filter rejects a selected route, no other route is
#     propagated for that network. This option allows to try the next route in
#     order until one that is accepted is found or all routes for that network
#     are rejected. This can be used for route servers that need to propagate
#     different tables to each client but do not want to have these tables
#     explicitly (to conserve memory). This option requires that the connected
#     routing table is sorted. Default: false.
#
# @param
#   setkey
#     On BSD systems, keys for TCP MD5 authentication are stored in the global
#     SA/SP database, which can be accessed by external utilities (e.g.
#     setkey(8)). BIRD configures security associations in the SA/SP database
#     automatically based on password options (see above), this option allows
#     to disable automatic updates by BIRD when manual configuration by
#     external utilities is preferred. Note that automatic SA/SP database
#     updates are currently implemented only for FreeBSD. Passwords have to be
#     set manually by an external utility on NetBSD and OpenBSD. Default:
#     true (ignored on non-FreeBSD).
#
# @param
#   source_ip
#     Define local address we should use for next hop calculation and as a
#     source address for the BGP session. Default: the address of the local end
#     of the interface our neighbor is connected to.
#
# @param
#   startup_hold_time
#     Value of the hold timer used before the routers have a chance to exchange
#     open messages and agree on the real value. Default: 240 seconds.
#
# @param
#   ttl_security
#     Use GTSM (RFC 5082 - the generalized TTL security mechanism). GTSM
#     protects against spoofed packets by ignoring received packets with
#     a smaller than expected TTL. To work properly, GTSM have to be enabled
#     on both sides of a BGP session. If both ttl security and multihop options
#     are enabled, multihop option should specify proper hop value to compute
#     expected TTL. Kernel support required: Linux: 2.6.34+ (IPv4),
#     2.6.35+ (IPv6), BSD: since long ago, IPv4 only. Note that full (ICMP
#     protection, for example) RFC 5082 support is provided by Linux only.
#     Default: false.
#
# @param
#   type
#     Specifies 'template' or 'protocol'
#
define bird::bgp (
  Stdlib::Absolutepath $conf_path,

  Enum['protocol', 'template'] $type = 'protocol',

  String[1] $export_filter = 'none',
  String[1] $import_filter = 'all',

  Optional[Variant[Boolean, Enum['rx', 'tx']]] $add_paths = undef,
  Optional[Boolean] $advertise_ipv4 = undef,
  Optional[Integer[0,100]] $allow_local_as = undef,
  Optional[Boolean] $as4 = undef,
  Optional[Boolean] $bfd = undef,
  Optional[Boolean] $capabilities = undef,
  Optional[Boolean] $check_link = undef,
  Optional[Integer[1]] $connect_delay_time = undef,
  Optional[Integer[1]] $connect_retry_time = undef,
  Optional[Integer[0]] $default_bgp_local_pref = undef,
  Optional[Integer[0]] $default_bgp_med = undef,
  Optional[Boolean] $deterministic_med = undef,
  Optional[Boolean] $direct = undef,
  Optional[Boolean] $disable_after_error = undef,
  Optional[Integer[1]] $error_forget_time = undef,
  Optional[Pattern[/\A\d+,\s*\d+\Z/]] $error_wait_time = undef,
  Optional[Boolean] $extended_messages = undef,
  Optional[Enum['direct', 'recursive']] $gateway = undef,
  Optional[Variant[Boolean, Enum['aware']]] $graceful_restart = undef,
  Optional[Integer[0,1000]] $graceful_restart_time = undef,
  Optional[Integer[1]] $hold_time = undef,
  Optional[Boolean] $igp_metric = undef,
  Optional[Boolean] $interpret_communities = undef,
  Optional[Integer[1]] $keepalive_time = undef,
  Optional[Integer[1]] $local_as = undef,
  Optional[Boolean] $med_metric = undef,
  Optional[Variant[Boolean, Integer[1]]] $multihop = undef,
  Optional[Boolean] $next_hop_self = undef,
  Optional[Boolean] $next_hop_keep = undef,
  Optional[Boolean] $passive = undef,
  Optional[String[1]] $password = undef,
  Optional[Boolean] $path_metric = undef,
  Optional[Boolean] $prefer_older = undef,
  Optional[Integer[1]] $remote_as = undef,
  Optional[Stdlib::Compat::Ipv4] $remote_ip = undef,
  Optional[Integer[1, 65535]] $remote_port = undef,
  Optional[Integer[1]] $route_limit = undef,
  Optional[Boolean] $route_refresh = undef,
  Optional[Boolean] $rr_client = undef,
  Optional[Stdlib::Compat::Ipv4] $rr_cluster_id = undef,
  Optional[Boolean] $rs_client = undef,
  Optional[Boolean] $secondary = undef,
  Optional[Boolean] $setkey = undef,
  Optional[Stdlib::Compat::Ipv4] $source_ip = undef,
  Optional[Integer[1]] $startup_hold_time = undef,
  Optional[Boolean] $ttl_security = undef,
) {

  unless defined(Concat[$conf_path]) {
    fail("You must include the 'bird' base class before using any bird::bgp defined types.")
  }

  if ($type == 'protocol' and undef in [$local_as, $remote_ip]) {
    fail("You must specify a 'local_as' and 'remote_ip'.")
  }

  $add_paths_ = $add_paths ? {
    true    => 'on',
    false   => 'off',
    default => $add_paths,
  }

  $advertise_ipv4_ = $advertise_ipv4 ? {
    true    => 'on',
    false   => 'off',
    default => $advertise_ipv4,
  }

  $as4_ = $as4 ? {
    true    => 'on',
    false   => 'off',
    default => $as4,
  }

  $bfd_ = $bfd ? {
    true    => 'on',
    false   => 'off',
    default => $bfd,
  }

  $capabilities_ = $capabilities ? {
    true    => 'on',
    false   => 'off',
    default => $capabilities,
  }

  $check_link_ = $check_link ? {
    true    => 'on',
    false   => 'off',
    default => $check_link,
  }

  $deterministic_med_ = $deterministic_med ? {
    true    => 'on',
    false   => 'off',
    default => $deterministic_med,
  }

  $disable_after_error_ = $disable_after_error ? {
    true    => 'on',
    false   => 'off',
    default => $disable_after_error,
  }

  $extended_messages_ = $extended_messages ? {
    true    => 'on',
    false   => 'off',
    default => $extended_messages,
  }

  $graceful_restart_ = $graceful_restart ? {
    true    => 'on',
    false   => 'off',
    default => $graceful_restart,
  }

  $igp_metric_ = $igp_metric ? {
    true    => 'on',
    false   => 'off',
    default => $igp_metric,
  }

  $interpret_communities_ = $interpret_communities ? {
    true    => 'on',
    false   => 'off',
    default => $interpret_communities,
  }

  $med_metric_ = $med_metric ? {
    true    => 'on',
    false   => 'off',
    default => $med_metric,
  }

  $path_metric_ = $path_metric ? {
    true    => 'on',
    false   => 'off',
    default => $path_metric,
  }

  $prefer_older_ = $prefer_older ? {
    true    => 'on',
    false   => 'off',
    default => $prefer_older,
  }

  $route_refresh_ = $route_refresh ? {
    true    => 'on',
    false   => 'off',
    default => $route_refresh,
  }

  $secondary_ = $secondary ? {
    true    => 'on',
    false   => 'off',
    default => $secondary,
  }

  $setkey_ = $setkey ? {
    true    => 'on',
    false   => 'off',
    default => $setkey,
  }

  $ttl_security_ = $ttl_security ? {
    true    => 'on',
    false   => 'off',
    default => $ttl_security,
  }

  concat::fragment { "bird_conf_50_bgp_${name}":
    content => epp('bird/bgp.conf.epp', {
      add_paths              => $add_paths_,
      advertise_ipv4         => $advertise_ipv4_,
      allow_local_as         => $allow_local_as,
      as4                    => $as4_,
      bfd                    => $bfd_,
      capabilities           => $capabilities_,
      check_link             => $check_link_,
      connect_delay_time     => $connect_delay_time,
      connect_retry_time     => $connect_retry_time,
      default_bgp_local_pref => $default_bgp_local_pref,
      default_bgp_med        => $default_bgp_med,
      deterministic_med      => $deterministic_med_,
      direct                 => $direct,
      disable_after_error    => $disable_after_error_,
      export_filter          => $export_filter,
      error_forget_time      => $error_forget_time,
      error_wait_time        => $error_wait_time,
      extended_messages      => $extended_messages_,
      gateway                => $gateway,
      graceful_restart       => $graceful_restart_,
      graceful_restart_time  => $graceful_restart_time,
      hold_time              => $hold_time,
      igp_metric             => $igp_metric_,
      import_filter          => $import_filter,
      interpret_communities  => $interpret_communities_,
      keepalive_time         => $keepalive_time,
      local_as               => $local_as,
      med_metric             => $med_metric_,
      multihop               => $multihop,
      name                   => $name,
      next_hop_keep          => $next_hop_keep,
      next_hop_self          => $next_hop_self,
      password               => $password,
      path_metric            => $path_metric_,
      prefer_older           => $prefer_older_,
      remote_as              => $remote_as,
      remote_ip              => $remote_ip,
      remote_port            => $remote_port,
      route_limit            => $route_limit,
      route_refresh          => $route_refresh_,
      rr_client              => $rr_client,
      rr_cluster_id          => $rr_cluster_id,
      rs_client              => $rs_client,
      secondary              => $secondary_,
      setkey                 => $setkey_,
      source_ip              => $source_ip,
      startup_hold_time      => $startup_hold_time,
      ttl_security           => $ttl_security_,
      type                   => $type,
    }),
    order   => 50,
    target  => $conf_path,
  }
}
