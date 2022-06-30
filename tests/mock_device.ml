open Mock

let test_get_devices_id =
  Alcotest.test_case "Device.get_from" `Quick @@ fun () ->
  let raw_json =
    {|{
        "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
        "short_id": "string",
        "hostname": "string",
        "description": "string",
        "state": "active",
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
          "slug": "debian_10",
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
          "code": "SP",
          "country": "string"
        },
        "plan": {
          "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
          "slug": "c3.small.x86",
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
  let module E = (val mock [ (Get "devices/dev42", raw_json) ]) in
  let t = E.create ~address ~token () in
  let open E.Device in
  let config = get_from t ~id:(id_of_string "dev42") in
  Alcotest.(check string) "hostname" config.hostname "string";
  Alcotest.(check (list string)) "tags" config.tags [ "string" ];
  Alcotest.(check string) "user" config.user "string";
  assert (config.location = Sao_paulo);
  assert (config.os = Debian_10);
  assert (config.state = Active)

let test_get_projects_id_devices =
  Alcotest.test_case "Device.get_all_from_project" `Quick @@ fun () ->
  let raw_json =
    {|{
        "devices": [
          {
            "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
            "short_id": "string",
            "hostname": "string",
            "description": "string",
            "state": "provisioning",
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
              "slug": "debian_9",
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
              "code": "AM",
              "country": "string"
            },
            "plan": {
              "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
              "slug": "c3.medium.x86",
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
  let open E.Device in
  let devices =
    get_all_from_project t ~id:(E.Project.id_of_string "myproject")
  in
  match devices with
  | [ config ] ->
      Alcotest.(check string) "hostname" config.hostname "string";
      Alcotest.(check (list string)) "tags" config.tags [ "string" ];
      Alcotest.(check string) "user" config.user "string";
      assert (config.location = Amsterdam);
      assert (config.os = Debian_9);
      assert (config.state = Provisioning)
  | _ -> Alcotest.fail "expected one device"

let test_get_devices_id_events =
  Alcotest.test_case "Device.get_events_from" `Quick @@ fun () ->
  let raw_json =
    {|{
        "events": [
          {
            "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
            "state": "powering_off",
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
  let module E = (val mock [ (Get "devices/i64/events", raw_json) ]) in
  let t = E.create ~address ~token () in
  let events = E.Device.(get_events_from t ~id:(id_of_string "i64")) in
  match events with
  | [ single ] ->
      let open E.Event in
      Alcotest.(check string) "event_type" single.event_type "string";
      Alcotest.(check string) "tags" single.body "string";
      assert (single.state = Powering_off)
  | _ -> Alcotest.fail "expected one event"

let test_post_devices_id_actions =
  Alcotest.test_case "Device.execute_action_on" `Quick @@ fun () ->
  let module E =
  (val mock
         [
           (Post ("devices/abc/actions?type=power_on", ""), "");
           (Post ("devices/def/actions?type=power_off", ""), "");
           (Post ("devices/ghi/actions?type=reboot", ""), "");
           (Post ("devices/jkl/actions?type=rescue", ""), "");
           (Post ("devices/mno/actions?type=reinstall", ""), "");
         ])
  in
  let t = E.create ~address ~token () in
  let open E.Device in
  execute_action_on t ~id:(id_of_string "abc") ~action:Power_on;
  execute_action_on t ~id:(id_of_string "def") ~action:Power_off;
  execute_action_on t ~id:(id_of_string "ghi") ~action:Reboot;
  execute_action_on t ~id:(id_of_string "jkl") ~action:Rescue;
  execute_action_on t ~id:(id_of_string "mno") ~action:Reinstall

let test_delete_devices_id =
  Alcotest.test_case "Device.delete" `Quick @@ fun () ->
  let module E =
  (val mock
         [
           (Delete "devices/XYZ", "");
           (Delete "devices/DEAD?force_delete=true", "");
         ])
  in
  let t = E.create ~address ~token () in
  let open E.Device in
  delete t ~id:(id_of_string "XYZ") ();
  delete t ~id:(id_of_string "DEAD") ~force:true ()

let test_create =
  Alcotest.test_case "Device.create" `Quick @@ fun () ->
  let raw_json =
    {|{
        "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
        "short_id": "string",
        "hostname": "string",
        "description": "string",
        "state": "queued",
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
          "slug": "ubuntu_21_04",
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
          "code": "FR",
          "country": "string"
        },
        "plan": {
          "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
          "slug": "c3.small.x86",
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
    {|{"metro":"DC","plan":"c3.small.x86","operating_system":"debian_10","hostname":"device1","tags":["tag"]}|}
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
  let open E.Device in
  let config1 =
    build ~hostname:"device1" ~tags:[ "tag" ] ~location:Washington
      ~plan:C3_small_x86 ~os:Debian_10 ()
  in
  let config = create t ~id:(E.Project.id_of_string "aze") config1 in
  Alcotest.(check string) "hostname" config.hostname "string";
  Alcotest.(check (list string)) "tags" config.tags [ "string" ];
  Alcotest.(check string) "user" config.user "string";
  assert (config.location = Frankfurt);
  assert (config.os = Ubuntu_21_04);
  assert (config.state = Queued);
  let config2 =
    build ~hostname:"device2" ~location:Amsterdam ~plan:C3_medium_x86
      ~os:Ubuntu_21_04 ()
  in
  let config = create t ~id:(E.Project.id_of_string "rty") config2 in
  Alcotest.(check string) "hostname" config.hostname "string";
  Alcotest.(check (list string)) "tags" config.tags [ "string" ];
  Alcotest.(check string) "user" config.user "string";
  assert (config.location = Frankfurt);
  assert (config.os = Ubuntu_21_04);
  assert (config.state = Queued)

let test_update =
  Alcotest.test_case "Device.update" `Quick @@ fun () ->
  let raw_json =
    {|{
        "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
        "short_id": "string",
        "hostname": "string",
        "description": "string",
        "state": "queued",
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
          "slug": "ubuntu_21_04",
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
          "code": "FR",
          "country": "string"
        },
        "plan": {
          "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
          "slug": "c3.small.x86",
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
  let device = {|{"hostname":"device","tags":["tag"]}|} in
  let module E = (val mock [ (Put ("devices/foo", device), raw_json) ]) in
  let t = E.create ~address ~token () in
  let open E.Device in
  let config =
    update t ~id:(id_of_string "foo") ~hostname:"device" ~tags:[ "tag" ] ()
  in
  Alcotest.(check string) "hostname" config.hostname "string";
  Alcotest.(check (list string)) "tags" config.tags [ "string" ];
  assert (config.os = Ubuntu_21_04);
  assert (config.state = Queued)

let tests =
  [
    test_get_devices_id;
    test_get_projects_id_devices;
    test_get_devices_id_events;
    test_post_devices_id_actions;
    test_delete_devices_id;
    test_create;
    test_update;
  ]
