import { useState } from 'react';
import { Link } from 'react-router-dom';
import {
  ClipboardIcon,
  CheckIcon,
  LinkIcon,
  ArrowPathIcon
} from '@heroicons/react/24/outline';
import { Button } from '@material-tailwind/react';
import { useCopyToClipboard } from 'usehooks-ts';

function App() {
  const [longUrl, setLongUrl] = useState<string>('');
  const [shortUrl, setShortUrl] = useState<string>('-----');
  const [, copy] = useCopyToClipboard();

  const [copied, setCopied] = useState(false);

  const fetchShortUrl = async () => {
    console.log('Shorten URL', shortUrl);
    setShortUrl('https://short.url/abc123');
  };

  return (
    <div id="contact" className="flex h-screen justify-center items-center">
      <div className="container h-[80%] flex flex-row rounded-xl shadow-lg justify-center items-center bg-gray-900">
        <div className="flex flex-col w-1/2">
          <div className="">
            <h1 className="font-serif text-xl text-gray-200 text-center">
              The Simplest URL Shortner You Were Waiting For
            </h1>

            <div className="flex flex-row justify-between my-4 h-10">
              <div className="relative w-[89%]">
                <div className="absolute inset-y-0 start-0 flex items-center ps-4 pointer-events-none">
                  <LinkIcon className="h-4 w-4 text-gray-700" />
                </div>

                <input
                  className="text-gray-300 h-10 font-serif w-full p-3 ps-10 placeholder-gray-700 bg-gray-900 border border-gray-700 rounded-lg leading-tight"
                  type="url"
                  placeholder="Enter your link here..."
                  value={longUrl}
                  onChange={e => setLongUrl(e.target.value)}
                />
              </div>

              <Button
                className="flex items-center justify-center border border-gray-700 rounded-lg shadow bg-gray-900 w-[9%] text-sm font-semibold"
                type="button"
                onClick={() => fetchShortUrl()}
              >
                <ArrowPathIcon className="h-5 w-5 text-gray-300" />
              </Button>
            </div>

            <div className="flex flex-row justify-between h-10">
              <Link
                to={shortUrl}
                target="_blank"
                className="ps-5 font-serif flex items-center bg-gray-900 border border-gray-700 rounded-lg w-[78%] leading-tight text-blue-300"
              >
                {shortUrl}
              </Link>

              <Button
                className="flex font-serif items-center justify-center gap-3 p-2 border border-gray-700 rounded-lg shadow bg-gray-900 w-[20%] text-sm font-semibold text-gray-400"
                onClick={() => {
                  copy('Hello world');
                  setCopied(true);
                }}
                onMouseLeave={() => setCopied(false)}
              >
                {copied ? (
                  <>
                    <CheckIcon className="h-4 w-4 text-gray-300" />
                    Copied
                  </>
                ) : (
                  <>
                    <ClipboardIcon className="h-4 w-4 text-white" /> Copy Link
                  </>
                )}
              </Button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
