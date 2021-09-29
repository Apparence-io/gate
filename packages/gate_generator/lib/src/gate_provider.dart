class S1 {}

class S2 {}

class S3 {
  S3(S1 s1);
}

class GateProvider {
  S1 getS1() => S1();

  S2 getS2() => S2();

  S3 getS3() => S3(getS1());
}
