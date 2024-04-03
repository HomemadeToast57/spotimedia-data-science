import { useState } from 'react'
import Reddit from './Reddit.jsx'
import Youtube from './Youtube.jsx'
import './App.css';

function App() {
  const platforms = ['reddit', 'youtube', 'both'];
  const [platform, setPlatform] = useState('reddit');
  const [showContributorsModal, setShowContributorsModal] = useState(false);

  const toggleContributorsModal = () => {
    setShowContributorsModal(prevShow => !prevShow);
  };

  return (
      <div className="app">

            <nav className="navbar">
                <h1 className="title">CS415</h1>
                <button onClick={toggleContributorsModal} className="contributors-button">
                    Contributors
                </button>
            </nav>


            {showContributorsModal && (
                <div className="modal">
                    <div className="modal-content">
                        <span className="close" onClick={toggleContributorsModal}>&times;</span>
                        <ul>
                            <li>Jack Singer</li>
                            <li>Leora Dallas</li>
                            <li>Brandon Caravino</li>
                            <li>Jason Vitale</li>
                        </ul>
                    </div>
                </div>
            )}

          <select
              value={platform}
              onChange={(e) => setPlatform(e.target.value)}
              className="select"
          >
              {platforms.map((platform) => (
                  <option key={platform} value={platform}>
                      {platform}
                  </option>
              ))}
          </select>
          {platform === 'reddit' || platform === 'both' ? 
            <div className="chart-wrapper">
                <Reddit />
            </div> 
          : null}
          {platform === 'youtube' || platform === 'both' ? 
              <div className="chart-wrapper">
                <Youtube />
              </div> 
          : null}
        </div>
    );
}

export default App;
