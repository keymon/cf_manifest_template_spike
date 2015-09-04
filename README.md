# Spike: SPIKE: How do we manage manifest files between AWS and GCE


> The builds of GCE and AWS are more different that we would like when
> we deploy CF. The constraints are largely introduced by GCE and we would prefer
> not to degrade AWS in order to accommodate GCE. Having said that we would also
> like to minimise the amount of maintenance work that is required for the manifest file.
>
> The purpose of this spike is to find out if there is a clean way to manage
> the common areas of the manifest file while at the same time allowing
> divergence where it is necessary for us to deploy to GCE.
>
> **Acceptance Criteria**
> This is spike is complete when we have:
> - one or more options that we could implement in order to manage the manifest files for AWS and GCE
> - a prototype of how this would work

# Spike analysis

## Desired features

Some mininum features:

 * To be able to perform interpolation of variables, to allow us to:
   * Predefine a set of variables which can be reused in the config.
   * Refer to other parts of the YAML file

 * Allow us to split the configuration in different files in ordet to:
   * Implement some kind of inclusion logic.
   * Potentially split:
     - name
     - director_uuid
     - releases
     - networks
     - resource\_pools
     - disk_pools
     - properties
     - jobs/*...
       - api.yml
       - dea.yml
       - health_manager.yml
       - loggregator.yml
       - nats.yml
       - uaa.yml
       - ...

 * Allow us to separate the configuration of different platforms. E.g.:
   * Different resource pools for AWS and GCE

 * Provide a way to extract information from terraform.

Additionally to:

 * Be able to inject custom variables as arguments (e.g. environment)
 * Call a external script to get some info (e.g. `bosh status --uuid`)
 * Keep the original structure and order of the YAML.


## Generic templating engines

The idea is just use some kind of templating engine to render the YAML file:

 * ERB for ruby
 * jinja2 for python, etc.

Pros:
 * More extensible, we can program additional features and used advanced logic.
 * We can add code inline in the templates.
 * We can do it in a way that we keep the original structure.

Cons:
 * Not natively designed for YAML. Access to other yaml values is not natural and requires
   some development code.

### Simple example

[This template is a basic example of ERB](https://gist.github.com/frodenas/6711234bab7a28d422b4)

### Proof of Concept: ERB

In the `erb/` folder we provide a script `myspiff.rb` to merge multiple files.

This script receives a list of files to processed in order, supporting these types:

  * `*.yml` plain yaml files,  will be loaded directly.
  * `*.erb.yml` ERB yaml files, will be processed by ERB and then loaded as YAML.
  * `*.rb` plain ruby, it will be evaluated directly. Good to define some variables.

Features:

 * Multiple files can be used to create a new manifest, the YAML structure will be simply loaded and merged
 * Search other YAML values:
    * A function called `search_yaml_values` allows search any yaml value in the processed files.
 * Does not keep the original structure, since the yaml is parsed.
 * You can also use ruby string interpolation, which will be processed with the final assembled yaml.
   This even allows copy an exising subtree of the yaml in other node.

To test it, check `erb/cf/` folder. You can run it with:

```
make erb
less erb/cf/generated.manifest-aws.yml
```


## Spiff

It is the tool used by cloudfoundry, but it is still in the incubator.

References:
 * RECOMMENDED: [Blog describing how to work with spiff](https://blog.starkandwayne.com/2015/03/31/decomposing-bosh-manifests-with-spiff/)
 * [Offitial examples](https://github.com/cloudfoundry-community/using-spiff-examples)
 * [Spiff repository](https://github.com/cloudfoundry-incubator/spiff)
 * [Templates of offitial CF release using spiff](https://github.com/cloudfoundry/cf-release/tree/master/templates), and [script which calls them](https://github.com/cloudfoundry/cf-release/blob/master/generate_deployment_manifest)


Pros:
 * YAML native, with primitives to read different values.
 * Specific functions for CF: ip allocation, etc.
 * CF people use it in the official CF release.

Cons:
 * A little bit difficult to use and learn.
 * Buggy. Several bugs, like [this one](https://github.com/cloudfoundry-incubator/spiff/issues/27)
 * Does not keep the original structure and comments.
 * They say that is NOT being active development.
   > NOTE: Active development on spiff is currently paused, including Pull Requests. Very severe issues will be addressed, and we will still be actively responding to requests for help via Issues
 * Its future is not clear, and [some users abandon it](https://github.com/cloudfoundry-incubator/spiff/issues/27#issuecomment-56316106):
   > I've personally stopped using spiff for my own projects. I've found it's easier to just manage a single manifest file and force myself to keep that deployment manifest simple.
   >
   > Spiff is great when it's used for really simple things or internally-managed plumbing, but when you get into more complicated things like cf-release, with its many use-cases, it explodes in complexity. The potential for "wrong answers" from spiff increases, which is scary for deployment manifests.

### About the future of SPIFF

it is explained in this question in cf-dev: https://lists.cloudfoundry.org/archives/list/cf-dev@lists.cloudfoundry.org/thread/IFSYKSXRVYG6QPXM36ZZSRVBUKYQKNVZ/

### Proof of concept

In the folder `spiff/` we include two examples: `cf` and `bosh`.


The most complete example is `cf`. Comments about the code:

 * Spiff is called from `spiff/Makefile` tasks.
   * The files must be in order
   * Spiff evaluates from the last file to the first, merging the references backwards.
 * Terraform values are extracted by creating a terraform template in the `common/` file
 * jobs are split in multiple files in `spiff/cf/jobs/*.yml`
   * They use the feature `<<: (merge)` to include previous definitions (jobs and properties) in other files.
   * See `spiff/cf/jobs/nats.yml` for a more complex example.
 * The `spiff/cf/cf-manifest-main.yml` just selects the yaml nodes we want to keep in the final file.
 * `spiff/cf/cf-manifest-common.yml`: Common code skeleton
   * Properties are merged from other stubs using `<<: (merge)`
   * Example of string interpolation in the domain value.
 * The `director_uuid.yml` is generated by the Makefile
 * `cf-manifes-{gce,aws}.yml` have the specific values of each platform.

