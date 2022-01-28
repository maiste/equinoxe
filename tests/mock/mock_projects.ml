open Mock

let test_get_projects =
  Alcotest.test_case "Projects.get_projects" `Quick @@ fun () ->
  let raw_json =
    {|{
        "projects": [
          {
            "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
            "name": "string",
            "created_at": "2019-08-24T14:15:22Z",
            "updated_at": "2019-08-24T14:15:22Z",
            "max_devices": {},
            "members": [
              {
                "href": "string"
              }
            ],
            "memberships": [
              {
                "href": "string"
              }
            ],
            "network_status": {},
            "invitations": [
              {
                "href": "string"
              }
            ],
            "payment_method": {
              "href": "string"
            },
            "devices": [
              {
                "href": "string"
              }
            ],
            "ssh_keys": [
              {
                "href": "string"
              }
            ],
            "volumes": [
              {
                "href": "string"
              }
            ],
            "bgp_config": {
              "href": "string"
            },
            "customdata": {}
          }
        ],
        "meta": {
          "first": {
            "href": "string"
          },
          "previous": {
            "href": "string"
          },
          "self": {
            "href": "string"
          },
          "next": {
            "href": "string"
          },
          "last": {
            "href": "string"
          },
          "total": 0
        }
      }|}
  in
  let module E = (val mock [ (Get "projects", raw_json) ]) in
  let t = E.create ~address ~token () in
  let json = E.Projects.get_projects t in
  let expected_json = Ezjsonm.from_string raw_json in
  Alcotest.(check ezjsonm) "json" expected_json json

let test_get_projects_id =
  Alcotest.test_case "Projects.get_projects_id" `Quick @@ fun () ->
  let raw_json =
    {|{
        "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
        "name": "string",
        "created_at": "2019-08-24T14:15:22Z",
        "updated_at": "2019-08-24T14:15:22Z",
        "max_devices": {},
        "members": [
          {
            "href": "string"
          }
        ],
        "memberships": [
          {
            "href": "string"
          }
        ],
        "network_status": {},
        "invitations": [
          {
            "href": "string"
          }
        ],
        "payment_method": {
          "href": "string"
        },
        "devices": [
          {
            "href": "string"
          }
        ],
        "ssh_keys": [
          {
            "href": "string"
          }
        ],
        "volumes": [
          {
            "href": "string"
          }
        ],
        "bgp_config": {
          "href": "string"
        },
        "customdata": {}
      }|}
  in
  let module E = (val mock [ (Get "projects/p1", raw_json) ]) in
  let t = E.create ~address ~token () in
  let json = E.Projects.get_projects_id t ~id:"p1" () in
  let expected_json = Ezjsonm.from_string raw_json in
  Alcotest.(check ezjsonm) "json" expected_json json

let test_get_projects_id_devices =
  Alcotest.test_case "Projects.get_projects_id_devices" `Quick @@ fun () ->
  let raw_json =
    {|{
        "devices": [
          {
            "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
            "short_id": "string",
            "hostname": "string",
            "description": "string",
            "state": "string",
            "tags": [
              "string"
            ],
            "image_url": "string",
            "billing_cycle": "string",
            "user": "string",
            "iqn": "string",
            "locked": true,
            "bonding_mode": 0,
            "created_at": "2019-08-24T14:15:22Z",
            "updated_at": "2019-08-24T14:15:22Z",
            "spot_instance": true,
            "spot_price_max": 0,
            "termination_time": "2019-08-24T14:15:22Z",
            "customdata": {},
            "provisioning_percentage": 0,
            "operating_system": {
              "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
              "slug": "string",
              "name": "string",
              "distro": "string",
              "version": "string",
              "preinstallable": true,
              "provisionable_on": [
                "string"
              ],
              "pricing": {},
              "licensed": true
            },
            "always_pxe": true,
            "ipxe_script_url": "string",
            "facility": {
              "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
              "name": "string",
              "code": "string",
              "features": [
                "baremetal",
                "backend_transfer",
                "global_ipv4"
              ],
              "ip_ranges": [
                "2604:1380::/36",
                "147.75.192.0/21"
              ],
              "address": {
                "address": "string",
                "address2": "string",
                "city": "string",
                "state": "string",
                "zip_code": "string",
                "country": "string",
                "coordinates": {
                  "latitude": "string",
                  "longitude": "string"
                }
              },
              "metro": {
                "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
                "name": "string",
                "code": "string",
                "country": "string"
              }
            },
            "metro": {
              "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
              "name": "string",
              "code": "string",
              "country": "string"
            },
            "plan": {
              "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
              "slug": "string",
              "name": "string",
              "description": "string",
              "line": "string",
              "specs": {},
              "pricing": {},
              "legacy": true,
              "class": "string",
              "available_in": [
                {
                  "href": "string"
                }
              ]
            },
            "userdata": "string",
            "root_password": "string",
            "switch_uuid": "string",
            "network_ports": {
              "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
              "type": "string",
              "name": "string",
              "data": {},
              "disbond_operation_supported": true,
              "virtual_networks": [
                {
                  "href": "string"
                }
              ],
              "href": "string"
            },
            "href": "string",
            "project": {
              "href": "string"
            },
            "project_lite": {
              "href": "string"
            },
            "volumes": [
              {
                "href": "string"
              }
            ],
            "hardware_reservation": {
              "href": "string"
            },
            "ssh_keys": [
              {
                "href": "string"
              }
            ],
            "ip_addresses": [
              {
                "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
                "address_family": 0,
                "netmask": "string",
                "public": true,
                "enabled": true,
                "cidr": 0,
                "management": true,
                "manageable": true,
                "global_ip": true,
                "assigned_to": {
                  "href": "string"
                },
                "network": "string",
                "address": "string",
                "gateway": "string",
                "href": "string",
                "created_at": "2019-08-24T14:15:22Z",
                "metro": {
                  "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
                  "name": "string",
                  "code": "string",
                  "country": "string"
                },
                "parent_block": {
                  "network": "string",
                  "netmask": "string",
                  "cidr": 0,
                  "href": "string"
                }
              }
            ],
            "provisioning_events": [
              {
                "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
                "state": "string",
                "type": "string",
                "body": "string",
                "relationships": [
                  {
                    "href": "string"
                  }
                ],
                "interpolated": "string",
                "created_at": "2019-08-24T14:15:22Z",
                "href": "string"
              }
            ]
          }
        ],
        "meta": {
          "first": {
            "href": "string"
          },
          "previous": {
            "href": "string"
          },
          "self": {
            "href": "string"
          },
          "next": {
            "href": "string"
          },
          "last": {
            "href": "string"
          },
          "total": 0
        }
      }|}
  in
  let module E = (val mock [ (Get "projects/myproject/devices", raw_json) ]) in
  let t = E.create ~address ~token () in
  let json = E.Projects.get_projects_id_devices t ~id:"myproject" () in
  let expected_json = Ezjsonm.from_string raw_json in
  Alcotest.(check ezjsonm) "json" expected_json json

let test_post_projects_id_devices =
  Alcotest.test_case "Projects.post_projects_id_devices" `Quick @@ fun () ->
  let raw_json =
    {|{
        "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
        "short_id": "string",
        "hostname": "string",
        "description": "string",
        "state": "string",
        "tags": [
          "string"
        ],
        "image_url": "string",
        "billing_cycle": "string",
        "user": "string",
        "iqn": "string",
        "locked": true,
        "bonding_mode": 0,
        "created_at": "2019-08-24T14:15:22Z",
        "updated_at": "2019-08-24T14:15:22Z",
        "spot_instance": true,
        "spot_price_max": 0,
        "termination_time": "2019-08-24T14:15:22Z",
        "customdata": {},
        "provisioning_percentage": 0,
        "operating_system": {
          "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
          "slug": "string",
          "name": "string",
          "distro": "string",
          "version": "string",
          "preinstallable": true,
          "provisionable_on": [
            "string"
          ],
          "pricing": {},
          "licensed": true
        },
        "always_pxe": true,
        "ipxe_script_url": "string",
        "facility": {
          "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
          "name": "string",
          "code": "string",
          "features": [
            "baremetal",
            "backend_transfer",
            "global_ipv4"
          ],
          "ip_ranges": [
            "2604:1380::/36",
            "147.75.192.0/21"
          ],
          "address": {
            "address": "string",
            "address2": "string",
            "city": "string",
            "state": "string",
            "zip_code": "string",
            "country": "string",
            "coordinates": {
              "latitude": "string",
              "longitude": "string"
            }
          },
          "metro": {
            "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
            "name": "string",
            "code": "string",
            "country": "string"
          }
        },
        "metro": {
          "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
          "name": "string",
          "code": "string",
          "country": "string"
        },
        "plan": {
          "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
          "slug": "string",
          "name": "string",
          "description": "string",
          "line": "string",
          "specs": {},
          "pricing": {},
          "legacy": true,
          "class": "string",
          "available_in": [
            {
              "href": "string"
            }
          ]
        },
        "userdata": "string",
        "root_password": "string",
        "switch_uuid": "string",
        "network_ports": {
          "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
          "type": "string",
          "name": "string",
          "data": {},
          "disbond_operation_supported": true,
          "virtual_networks": [
            {
              "href": "string"
            }
          ],
          "href": "string"
        },
        "href": "string",
        "project": {
          "href": "string"
        },
        "project_lite": {
          "href": "string"
        },
        "volumes": [
          {
            "href": "string"
          }
        ],
        "hardware_reservation": {
          "href": "string"
        },
        "ssh_keys": [
          {
            "href": "string"
          }
        ],
        "ip_addresses": [
          {
            "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
            "address_family": 0,
            "netmask": "string",
            "public": true,
            "enabled": true,
            "cidr": 0,
            "management": true,
            "manageable": true,
            "global_ip": true,
            "assigned_to": {
              "href": "string"
            },
            "network": "string",
            "address": "string",
            "gateway": "string",
            "href": "string",
            "created_at": "2019-08-24T14:15:22Z",
            "metro": {
              "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
              "name": "string",
              "code": "string",
              "country": "string"
            },
            "parent_block": {
              "network": "string",
              "netmask": "string",
              "cidr": 0,
              "href": "string"
            }
          }
        ],
        "provisioning_events": [
          {
            "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
            "state": "string",
            "type": "string",
            "body": "string",
            "relationships": [
              {
                "href": "string"
              }
            ],
            "interpolated": "string",
            "created_at": "2019-08-24T14:15:22Z",
            "href": "string"
          }
        ]
      }|}
  in
  let device1 =
    {|{"metro":"DC","plan":"c3.small.x86","operating_system":"debian_10","hostname":"device1"}|}
  in
  let device2 =
    {|{"metro":"AM","plan":"c3.medium.x86","operating_system":"ubuntu_21_04","hostname":"device2"}|}
  in
  let module E =
  (val mock
         [
           (Post ("projects/aze/devices", device1), raw_json);
           (Post ("projects/rty/devices", device2), raw_json);
         ])
  in
  let t = E.create ~address ~token () in
  let config1 =
    E.Devices.
      {
        hostname = "device1";
        location = Washington;
        plan = C3_small_x86;
        os = Debian_10;
      }
  in
  let json =
    E.Projects.post_projects_id_devices t ~id:"aze" ~config:config1 ()
  in
  let expected_json = Ezjsonm.from_string raw_json in
  Alcotest.(check ezjsonm) "json" expected_json json;
  let config2 =
    E.Devices.
      {
        hostname = "device2";
        location = Amsterdam;
        plan = C3_medium_x86;
        os = Ubuntu_21_04;
      }
  in
  let json =
    E.Projects.post_projects_id_devices t ~id:"rty" ~config:config2 ()
  in
  let expected_json = Ezjsonm.from_string raw_json in
  Alcotest.(check ezjsonm) "json" expected_json json

let tests =
  [
    test_get_projects;
    test_get_projects_id;
    test_get_projects_id_devices;
    test_post_projects_id_devices;
  ]
