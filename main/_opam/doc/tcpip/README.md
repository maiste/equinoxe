# mirage-tcpip - an OCaml TCP/IP networking stack

`mirage-tcpip` provides a networking stack for the [Mirage operating
system](https://mirage.io). It provides implementations for the following module types
(which correspond with the similarly-named protocols):

* IP (via the IPv4 and IPv6 modules)
* ICMP
* UDP
* TCP

## Implementations

There are two implementations of the IP, ICMP, UDP, and TCP module types -
the `socket` stack, and the `direct` stack.

### The `socket` stack

The `socket` stack uses socket calls to a traditional operating system to
provide the functionality described in the module types.

See the [`src/stack-unix/`](./src/stack-unix/) directory for the modules used as implementations of the
`socket` stack. 

The `socket` stack is used for testing or other applications which do not
expect to run as unikernels.

### The `direct` stack

The `direct` stack expects to write to a device implementing the `NETIF` module
type defined for MirageOS.

See the [`src/`](./src/) directory for the modules used as implementations of the
`direct` stack, which is the expected stack for most MirageOS applications.

The `direct` stack is the only usable set of implementations for
applications which will run as unikernels on a hypervisor target.

## Community

* WWW: <https://mirage.io>
* E-mail: <mirageos-devel@lists.xenproject.org>
* Issues: <https://github.com/mirage/mirage-tcpip/issues>
* API docs: <http://docs.mirage.io/tcpip/index.html>

## License

`mirage-tcpip` is distributed under the ISC license.
