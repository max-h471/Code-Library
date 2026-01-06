# Script to make API calls to Rapid7
import base64
import urllib3
import logging
import requests
import json

# file with hostnames you want to tag in the console
# input should be \n separated hostnames, NOT COMMA SEPARATED
base_file = 'C:\\path\\to\\your\\file.txt'

# disable the SSL certificate warning, otherwise script may error due to cert
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

base_host_url = "hxxps://hostname:consoleport.yourdomain.com"
# harcode credentials because I am bad at coding
# change these to be your creds
r7_username = "Your API User"
r7_password = "Your API User Credentials"

# header to be used in API request. R7 api requires base64 encoded creds
header = {
    "Authorization": "Basic " + base64.b64encode(f"{r7_username}:{r7_password}".encode('ascii')).decode(),
    "Accept": "application/json", "Content-Type": "application/json"
}

# Setup the logging for the script
# logger module will return HTTP response codes
def setup_logging():
    logger = logging.getLogger('Rapid7')
    logger.setLevel(logging.INFO)
    #
    console = logging.StreamHandler()
    console.setLevel(logging.INFO)
    #
    formatter = logging.Formatter('%(asctime)s [%(levelname)8s] %(message)s')
    console.setFormatter(formatter)
    logger.addHandler(console)
    #
    logger.info("Logging has been started...")

# API call function with get, post, and put clauses for proper request handling
def api_call(method=None, data=None, url=None, ssl_verify=False):
    if method.lower() == "post":
        response = requests.post(headers=header, json=data, url=url, verify=ssl_verify)
        return response.status_code, response.text

    if method.lower() == "get":
        response = requests.get(headers=header, url=url, verify=ssl_verify)
        if response.status_code == 201 or response.status_code == 200:
            return response.text
        # else clause to show error and exit script
        else:
            logging.error(f"Received: {response.status_code}, {response}, {url}, \n{response.request.headers}")
            raise SystemExit

    if method.lower() == "put":
        response = requests.put(headers=header, json=data, url=url, verify=ssl_verify)
        return response.status_code, response.text

# request body to hit the api URI at hxxps://host:port/api/3/tags
# this function will read hostnames from the text file and tag them 
def CreateTag():
    # enter an input file with hostnames
    status_code, response_body = api_call(method="post", url=base_host_url + "/api/3/tags")
    # file input should be \n separated hostnames, NOT COMMA SEPARATED
    with open(base_file, 'r+') as input_file:
        # iterate through hosts in input file and use various hosts as multiple inputs
        lines = [line.strip() for line in input_file if line.strip()]
        filters = [
            {
                "field": "host-name",
                "operator": "contains",
                "value": host
            } for host in lines
        ]
# API request body found at https://help.rapid7.com/insightvm/en-us/api/index.html#tag/Tag/operation/createTag
    api_args = {
        "color": "default",
        # timestamp not needed but can be used
        #"created": "2026-01-05T09:00:00.000Z",
        "name": "YOUR TAG NAME", # tag name to be created, modify this
        "searchCriteria": {
            "filters": filters,
            "match": "any"
        },
        "type": "custom"
    }
    status_code, response_body = api_call(method="post", url=base_host_url + "/api/3/tags", data=api_args, ssl_verify=False)

    logging.info(f"CreateTag returned {status_code}: {response_body}")
    # return a tuple so main() can work with returned data, otherwise error
    return status_code, response_body

# similar to the above function, but this one will tag single hostnames you define and not read from a text file
def CreateTagSingle():
    # enter an input file with hostnames
    status_code, response_body = api_call(method="post", url=base_host_url + "/api/3/tags")
# API request body found at https://help.rapid7.com/insightvm/en-us/api/index.html#tag/Tag/operation/createTag
    api_args = {
        # If your console rejects "default", remove this or use a hex color (e.g., "#0078D4")
        "color": "default",
        "name": "YOUR TAG NAME", # variable input, modify this
        "searchCriteria": {
            "filters": [
                {
                    "field": "host-name",    # same field you used in CreateTag()
                    "operator": "contains",  # supported operator for host-name
                    "value": "YOUR ASSETS HOSTNAME" # variable input, modify this
                }
            ],
            "match": "any" # ref: https://help.rapid7.com/insightvm/en-us/api/index.html#section/Overview/Responses under "Operator Properties"
        },
        "type": "custom"
    }

    # log the payload to see servers response
    logging.info("POST /api/3/tags payload: %s", json.dumps(api_args, indent=2))

    status_code, response_body = api_call(method="post",url=base_host_url + "/api/3/tags",data=api_args,ssl_verify=False
    )

    logging.info(f"CreateTagSingle returned {status_code}: {response_body}")
    return status_code, response_body

def main():
    # main used to run whatever API function you are using
    status_code, response_body = CreateTag() # uncomment if you are reading multiple hosts from a file
    #status_code, response_body = CreateTagSingle() # uncomment if you are doing a single host
    logging.getLogger('Rapid7').info("Script has completed.")

setup_logging()
main()
