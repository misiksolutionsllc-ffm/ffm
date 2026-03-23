import { useState } from 'react'
import './App.css'

function App() {
  const [count, setCount] = useState(0)

  return (
    <div className="app">
      <header className="app-header">
        <h1>FFM App</h1>
        <p>Welcome to your new React application.</p>
      </header>
      <main className="app-main">
        <div className="card">
          <button onClick={() => setCount((c) => c + 1)}>
            Count is {count}
          </button>
          <p>Edit <code>src/App.tsx</code> and save to test HMR.</p>
        </div>
      </main>
    </div>
  )
}

export default App
