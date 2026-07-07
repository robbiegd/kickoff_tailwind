export default function HelloReact({ name = "React" }) {
  return (
    <div className="flex items-center gap-2 flex-wrap">
      <span className="font-semibold text-indigo-700">Hello from {name}! ⚛️</span>
      <span className="text-gray-600 text-sm">
        This component is rendered by React inside an ERB view.
      </span>
    </div>
  )
}
