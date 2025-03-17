import React, { useState } from 'react';
import './App.css';
import VotingForm from './components/VotingForm';

const App = () => {
  return (
    <div className="App">
      <h1>Toastmasters Voting System</h1>
      <VotingForm />
    </div>
  );
}

export default App;
