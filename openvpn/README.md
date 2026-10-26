We don't generate or provide any keys or certificates for OpenVPN. You'll need to generate your own and populate the server. You can do that with Dojo using the `file upload` command.

On the system that is to run OpenVPN:

```
doj service key generate openvpn.default ORGNAME
doj start karate/openvpn --group default --org ORGNAME
```

On the local system that has the OpenVPN keys/certificates (e.g., a laptop/workstation), copy the generated `openvpn.default@ORGNAME-timestamp.pub` file (e.g., in `/doj/cache/keys`) to the local system to the key cache (e.g., `~/.doj/cache/keys`). Then do the following:

```
doj user key generate USERNAME
```

Copy the generated `USERNAME-timestamp.pub` to the OpenVPN system key cache (e.g., `/doj/cache/keys`). Then upload the OpenVPN certificates and keys.

```
for i in ca.crt server.crt server.key dh1024.pem
do
  doj file upload --org ORGNAME --peer 172.17.0.4 openvpn.default $i 1 USERNAME
done
```
