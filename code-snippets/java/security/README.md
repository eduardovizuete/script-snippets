# InstallCert.java

## Purpose
`InstallCert.java` is a utility for retrieving and installing SSL/TLS certificates from a remote server into a Java KeyStore. This is useful for trusting self-signed or untrusted certificates, especially when connecting to servers with custom or internal CA certificates.

## Usage
### Basic Usage
```
java InstallCert <host>[:port] [passphrase] [--quiet]
```
- `<host>`: The server hostname or IP address.
- `[:port]`: Optional port (default: 443).
- `[passphrase]`: Optional KeyStore password (default: `changeit`).
- `[--quiet]`: Automatically adds the first certificate without prompting.

### Proxy Support
```
java InstallCert --proxy=proxyHost:proxyPort <host>[:port] [passphrase] [--quiet]
```
- `--proxy=proxyHost:proxyPort`: Connect via HTTP proxy.

### Example
```
java InstallCert example.com:443
java InstallCert --proxy=proxy.local:8080 example.com:8443 mypassword --quiet
```

## How It Works
- Loads the Java KeyStore (`jssecacerts` or `cacerts`).
- Connects to the specified server (optionally via proxy).
- Retrieves the server's certificate chain.
- Displays certificate details (subject, issuer, SHA1, MD5).
- Prompts user to select a certificate to trust (unless `--quiet` is used).
- Adds the selected certificate to the KeyStore and saves it as `jssecacerts`.

## Requirements
- Java 7 or newer
- Network access to the target server
- Sufficient permissions to read/write KeyStore files

## Error Handling
- Provides usage instructions for invalid arguments
- Handles connection and SSL errors gracefully
- Validates user input when selecting certificates

## Notes
- Do **not** include sensitive information in scripts or KeyStore files.
- Use environment variables for configuration if automating.
- Always validate the certificate before trusting it.

## Attribution
Originally from Sun Microsystems (2006), adapted for modern Java versions.

## References
- [Original Source](http://blogs.sun.com/andreas/resource/InstallCert.java)
- [Java KeyStore Documentation](https://docs.oracle.com/javase/8/docs/api/java/security/KeyStore.html)
