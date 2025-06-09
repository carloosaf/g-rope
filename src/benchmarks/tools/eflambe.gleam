import gleam/erlang/atom.{type Atom}

pub type EflambeFormat {
  Svg
  BrendanGregg
}

pub type EflambeReturn {
  Value
  Flamegraph
  Filename
}

pub type EflambeOpenProgram {
  Speedscope
  Hotspot
}

pub type EflambeOptions {
  OutputFormat(EflambeFormat)
  Return(EflambeReturn)
  OutputDirectory(String)
  Open
}

@external(erlang, "eflambe", "apply")
pub fn apply(
  subject: #(fn(input_type) -> return, List(input_type)),
  list: List(EflambeOptions),
) -> void

pub fn capture(
  subject: #(String, String, Int),
  number_of_calls_to_capture: Int,
  options: List(EflambeOptions),
) {
  let atoms_subject = atom.create_from_string(subject.0)
  let atoms_subject2 = atom.create_from_string(subject.1)

  external_capture(
    #(atoms_subject, atoms_subject2, subject.2),
    number_of_calls_to_capture,
    options,
  )
}

@external(erlang, "eflambe", "capture")
fn external_capture(
  subject: #(Atom, Atom, Int),
  number_of_calls_to_capture: Int,
  options: List(EflambeOptions),
) -> void
