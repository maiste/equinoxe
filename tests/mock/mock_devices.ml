open Mock

let test_get_devices_id =
  Alcotest.test_case "Devices.get_devices_id" `Quick @@ fun () ->
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
  let module E = (val mock [ (Get "devices/dev42", raw_json) ]) in
  let t = E.create ~address ~token () in
  let json = E.Devices.get_devices_id t ~id:"dev42" () in
  let expected_json = Ezjsonm.from_string raw_json in
  Alcotest.(check ezjsonm) "json" expected_json json

let test_get_devices_id_events =
  Alcotest.test_case "Devices.get_devices_id_events" `Quick @@ fun () ->
  let raw_json =
    {|{
        "events": [
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
  let json = E.Devices.get_devices_id_events t ~id:"i64" () in
  let expected_json = Ezjsonm.from_string raw_json in
  Alcotest.(check ezjsonm) "json" expected_json json

let test_post_devices_id_actions =
  Alcotest.test_case "Devices.post_devices_id_actions" `Quick @@ fun () ->
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
  let json =
    E.Devices.post_devices_id_actions t ~id:"abc" ~action:E.Devices.Power_on ()
  in
  Alcotest.(check ezjsonm) "json" (`O []) json;
  let json =
    E.Devices.post_devices_id_actions t ~id:"def" ~action:E.Devices.Power_off ()
  in
  Alcotest.(check ezjsonm) "json" (`O []) json;
  let json =
    E.Devices.post_devices_id_actions t ~id:"ghi" ~action:E.Devices.Reboot ()
  in
  Alcotest.(check ezjsonm) "json" (`O []) json;
  let json =
    E.Devices.post_devices_id_actions t ~id:"jkl" ~action:E.Devices.Rescue ()
  in
  Alcotest.(check ezjsonm) "json" (`O []) json;
  let json =
    E.Devices.post_devices_id_actions t ~id:"mno" ~action:E.Devices.Reinstall ()
  in
  Alcotest.(check ezjsonm) "json" (`O []) json

let test_delete_devices_id =
  Alcotest.test_case "Devices.delete_devices_id" `Quick @@ fun () ->
  let module E =
  (val mock
         [
           (Delete "devices/XYZ", "");
           (Delete "devices/DEAD?force_delete=true", "");
         ])
  in
  let t = E.create ~address ~token () in
  let json = E.Devices.delete_devices_id t ~id:"XYZ" () in
  Alcotest.(check ezjsonm) "json" (`O []) json;
  let json = E.Devices.delete_devices_id t ~id:"DEAD" ~force:true () in
  Alcotest.(check ezjsonm) "json" (`O []) json

let test_get_devices_id_ips =
  Alcotest.test_case "Devices.get_devices_id_ips" `Quick @@ fun () ->
  let raw_json =
    {|{
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
        ]
      }|}
  in
  let module E = (val mock [ (Get "devices/toto/ips", raw_json) ]) in
  let t = E.create ~address ~token () in
  let json = E.Devices.get_devices_id_ips t ~id:"toto" () in
  let expected_json = Ezjsonm.from_string raw_json in
  Alcotest.(check ezjsonm) "json" expected_json json

let tests =
  [
    test_get_devices_id;
    test_get_devices_id_events;
    test_post_devices_id_actions;
    test_delete_devices_id;
    test_get_devices_id_ips;
  ]
