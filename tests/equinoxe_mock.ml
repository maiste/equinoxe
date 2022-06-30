let () =
  Alcotest.run "mock"
    [
      ("errors", Mock_errors.tests);
      ("auth", Mock_auth.tests);
      ("orga", Mock_orga.tests);
      ("device", Mock_device.tests);
      ("project", Mock_project.tests);
      ("user", Mock_user.tests);
    ]
