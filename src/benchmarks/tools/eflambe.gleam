pub type EflambeFormat {
  Svg
  BrendanGregg
}

pub type EflambeOptions {
  OutputFormat(EflambeFormat)
}

@external(erlang, "eflambe", "apply")
pub fn apply(
  subject: #(fn(input_type) -> return, List(input_type)),
  list: List(EflambeOptions),
) -> void
