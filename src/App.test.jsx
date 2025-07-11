import { render, screen, fireEvent } from '@testing-library/react'
import { describe, it, expect } from 'vitest'
import App from './App.jsx'

describe('App Component', () => {
  it('should render and increment count on button click', () => {
    render(<App />)

    const button = screen.getByRole('button', { name: /count is/i })

    expect(button.textContent).toBe('count is 0')

    fireEvent.click(button)
    expect(button.textContent).toBe('count is 1')

    fireEvent.click(button)
    expect(button.textContent).toBe('count is 2')
  })
})
