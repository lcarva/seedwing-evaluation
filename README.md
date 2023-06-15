# Seedwing Policy and Enterprise Contract

This repo serves as a preliminary way to evaluate whether or not [Enterprise
Contract](http://enterprisecontract.dev) should adopt [seedwing](https://seedwing.io) for policy
evaluation.

As an initial step, we try to use seedwing to create policy rules similar to the existing [CVE
Checks](https://enterprisecontract.dev/docs/ec-policies/release_policy.html#cve_package) written in
rego. These policy rules are relatively simple and should help us better understand how to work with
seedwing.

## Usage

To run the seedwing policies, use the `swio` binary from the latest [nightly
release](https://github.com/seedwing-io/seedwing-policy/releases). Then, run the following command:

```bash
swio eval --input input/good.json --policy policies --name cve::allow
```

That should succeed becauset `input/good.json` complies to the policy. Use the bad input to verify
the policy catches a non-compliant input:

```bash
swio eval --input input/bad.json --policy policies --name cve::allow
```

## Observations

- Error reporting is really nice on the web UI. It tells you exactly which part of the input didn't
  match a certain pattern.
- Are there controls to restrict access to environment variables and to prevent external access?
  (Capabilities in rego.)
- Bug: If .dog file ends in a comment out line without being followed by a newline, crash!
- Typos in dog files are caught but error usually points to irrelevant line.
- It would be nice if `list::some` could also be used as a filter. Return something meaningful so it
  can be used with `|`.
