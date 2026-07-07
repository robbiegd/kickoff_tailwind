import { createRoot } from "react-dom/client"
import HelloReact from "./hello_react"

// Register React components here to make them mountable from any ERB view:
//
//   <div data-react-component="HelloReact" data-react-props='{"name": "Rails"}'></div>
//
const components = { HelloReact }

const roots = new Map()

function mount() {
  document.querySelectorAll("[data-react-component]").forEach((el) => {
    if (roots.has(el)) return
    const Component = components[el.dataset.reactComponent]
    if (!Component) return
    const props = el.dataset.reactProps ? JSON.parse(el.dataset.reactProps) : {}
    const root = createRoot(el)
    root.render(<Component {...props} />)
    roots.set(el, root)
  })
}

// Unmount before Turbo caches the page so components re-mount cleanly
// on restoration visits.
function unmount() {
  roots.forEach((root) => root.unmount())
  roots.clear()
}

document.addEventListener("turbo:load", mount)
document.addEventListener("turbo:before-cache", unmount)
