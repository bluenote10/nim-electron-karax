include karax/prelude
import karax_utils

type
  # Elm's `model`
  Model = ref object
    toggle: bool


proc init(): Model =
  # Elm's `init`
  Model(toggle: true)


proc onClick(model: Model, ev: Event, n: VNode) =
  # Elm's `update`. Note that we could have
  # a global `update` like Elm as well. In this case
  # the event handlers would construct a message type
  # and pass it to a model update function.
  # See second ElmLike demo for an example
  kout(ev)
  kout(model)
  model.toggle = model.toggle xor true


proc view(model: Model): VNode =
  # Elm's `view`.
  result = buildHtml():
    tdiv:
      # message handler close over the model using the curry macro
      button(onclick=curry(onClick, model)):
        text "click me"
      tdiv:
        text "Toggle state:"
      tdiv:
        if model.toggle:
          text "true"
        else:
          text "false"

# Putting it all together
proc runMain() =
  var model = init()

  proc renderer(): VNode =
    view(model)

  kout("Setting renderer...")
  setRenderer(renderer, "ROOT")


runMain()