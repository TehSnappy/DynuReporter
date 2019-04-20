# DynuReporter
DynuReporter is a package for notifying the Dynu dynamic DNS API of a devices current IP address.

Use it to help access a server behind a dynamic IP address through a domain name. You will need an account with Dynu DDNS (https://dynu.com) in order for this package to do anything at all.

### Installation
Add `dynu_reporter` to your dependencies to include it in your project:

```elixir
  def deps do
    [
      {:dynu_reporter, "~> 1.0.0"}
    ]
  end
```

### Usage

Then set the necessary configuration That's all that DynuReporter needs

```elixir

  config :dynu_reporter,
    user_name: "USER_NAME",
    password: "UPDATE_PASSWORD",
    location: "DOMAIN_LOCATION",
    polling_interval: 1000 * 60 * 30 # 30 minutes

```
`USER_NAME`AND `UPDATE_PASSWORD` parameters correspond to your credential information with Dynu. Make sure not to use your real password, but instead create an update password for security reasons.
`DOMAIN_LOCATION` is a property you can use to group multiple domains to the same IP address. This should roughly correspond to the device you are running on in the case where you're hosting multiple domains or using multiple devices. 

DynuReporter will ping the Dynu DDNS API on startup of your application and notify it of your devices IP address. 
It can repeat this based on the `polling_interval` value in the config. The default of 0 will not poll the server.

The docs can be found at [https://hexdocs.pm/dynu_reporter](https://hexdocs.pm/dynu_reporter).

