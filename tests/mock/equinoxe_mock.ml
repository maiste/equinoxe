let () =
  Alcotest.run "mock"
    [
      ("errors", Mock_errors.tests);
      ("auth", Mock_auth.tests);
      ("orga", Mock_orga.tests);
      ("devices", Mock_devices.tests);
    ]
