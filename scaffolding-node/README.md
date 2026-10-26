# Dojo Node Scaffolding

Node Scaffolding is a Dojo package which helps you build your  [Node.js][node]-based **web applications**, **services**, and **processes** (hereafter referred to as "apps") into a package which runs consistently on a wide range of containers, virtual machines, or servers via the Dojo Supervisor. The Supervisor will facilitate clustering, discovery of external services such as databases, dynamically update configuration and credentials, coordinate reliable rolling updates, and a lot more!

* Dojo Website
* [Node Scaffolding Quickstart Guide](doc/quickstart.md)
* [Node Scaffolding Documentation](doc/reference.md)

# Pre-build, build, and post-build steps}

This scaffolding does support running build scripts, etc. that are defined in package.json. However, due to a known issue, you will need to run the Dojo services as "root" rather than the default "doj" user.  You can do this by adding this line to your plan.sh

```
pkg_svc_user=root
```

[node]: https://nodejs.org/en/
