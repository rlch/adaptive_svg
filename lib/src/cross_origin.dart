/// Values for the SVG `<image crossorigin>` attribute.
///
/// Controls how the browser fetches cross-origin images embedded in an SVG
/// via `<image href>`. The default (when not specified) is a **no-CORS**
/// fetch — the image loads but can't be read back from a canvas, and is
/// blocked entirely under `Cross-Origin-Embedder-Policy: require-corp`
/// unless the origin server sends a `Cross-Origin-Resource-Policy` header.
///
/// Setting this to [anonymous] forces a CORS-mode fetch that works as
/// long as the server responds with `Access-Control-Allow-Origin`.
enum CrossOrigin {
  /// Send the request without credentials (cookies, client certs).
  /// Server must respond with `Access-Control-Allow-Origin: *` or the
  /// requesting origin.
  anonymous('anonymous'),

  /// Send the request with credentials. Server must respond with a
  /// specific `Access-Control-Allow-Origin` (not `*`) plus
  /// `Access-Control-Allow-Credentials: true`.
  useCredentials('use-credentials');

  const CrossOrigin(this.value);

  /// HTML attribute value (e.g. `"anonymous"`, `"use-credentials"`).
  final String value;
}
