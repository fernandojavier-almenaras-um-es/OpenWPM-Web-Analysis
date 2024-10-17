#! /usr/bin/env python3

import sys
import os
import typing
import json
from argparse import ArgumentParser, Namespace
from pathlib import Path
from typing import Literal, List

from tranco import Tranco
from tranco.tranco import TrancoList

from openwpm.command_sequence import CommandSequence
from openwpm.commands.browser_commands import GetCommand, ScreenshotFullPageCommand
from openwpm.config import BrowserParams, ManagerParams
from openwpm.storage.sql_provider import SQLiteStorageProvider
from openwpm.storage.leveldb import LevelDbProvider
from openwpm.storage.local_storage import LocalArrowProvider
from openwpm.task_manager import TaskManager

parser: ArgumentParser = ArgumentParser()
parser.add_argument("--tranco", action="store_true", default=False)
parser.add_argument("--top", default=10, type=int)
parser.add_argument("--headless", action="store_true", default=False)
parser.add_argument("--sites", action="extend", nargs="+", type=str)

args: Namespace = parser.parse_args()

DISPLAY_MODE: Literal["native", "headless", "xvfb"] = os.getenv("DISPLAY_MODE", "native")
HTTP_INSTRUMENT: bool = os.getenv("HTTP_INSTRUMENT", "1") == "1"
COOKIE_INSTRUMENT: bool = os.getenv("COOKIE_INSTRUMENT", "1") == "1"
NAVIGATION_INSTRUMENT: bool = os.getenv("NAVIGATION_INSTRUMENT", "1") == "1"
JS_INSTRUMENT: bool = os.getenv("JS_INSTRUMENT", "1") == "1"
CALLSTACK_INSTRUMENT: bool = os.getenv("CALLSTACK_INSTRUMENT", "1") == "1"
DNS_INSTRUMENT: bool = os.getenv("DNS_INSTRUMENT", "1") == "1"
BOT_MITIGATION: bool = os.getenv("BOT_MITIGATION", "1") == "1"
#STEALTH_JS_INSTRUMENT: bool = os.getenv("STEALTH_JS_INSTRUMENT", "1") == "1"
JS_INSTRUMENT_SETTINGS: List[str | dict] = json.loads(
    os.getenv("JS_INSTRUMENT_SETTINGS", '["collection_fingerprinting"]')
)

SAVE_CONTENT: bool = os.getenv("SAVE_CONTENT", "0") == "1"
PREFS: dict[str] = os.getenv("PREFS", None)

NUM_BROWSERS: int = os.getenv("NUM_BROWSERS", 1)

TRANCO: bool = os.getenv("TRANCO", False)

sites: list[str] = None
if TRANCO or args.tranco:
    # Load the latest tranco list. See https://tranco-list.eu/
    print("Loading tranco top sites list...")
    t: Tranco = Tranco(cache=True, cache_dir=".tranco")
    latest_list: TrancoList = t.list()
    sites = ["http://" + page for page in latest_list.top(args.top)]

elif args.sites == None:
    print("No sites specified. Aborting.")
    sys.exit(0)

else:
    sites = args.sites

display_mode: Literal["native", "headless", "xvfb"] = DISPLAY_MODE
if args.headless:
    display_mode = "headless"

# Loads the default ManagerParams
# and NUM_BROWSERS copies of the default BrowserParams
manager_params: ManagerParams = ManagerParams(num_browsers=NUM_BROWSERS)
browser_params: list[BrowserParams] = [BrowserParams() for _ in range(NUM_BROWSERS)]

# Browser configuration
for i in range(NUM_BROWSERS):
    browser_params[i].display_mode = display_mode
    browser_params[i].http_instrument = HTTP_INSTRUMENT
    browser_params[i].cookie_instrument = COOKIE_INSTRUMENT
    browser_params[i].navigation_instrument = NAVIGATION_INSTRUMENT
    browser_params[i].callstack_instrument = False # not supported yet # CALLSTACK_INSTRUMENT
    browser_params[i].js_instrument = JS_INSTRUMENT
    browser_params[i].dns_instrument = DNS_INSTRUMENT
    browser_params[i].bot_mitigation = BOT_MITIGATION
    #browser_params[i].stealth_js_instrument = STEALTH_JS_INSTRUMENT
    browser_params[i].js_instrument_settings = JS_INSTRUMENT_SETTINGS
    browser_params[i].save_content = SAVE_CONTENT
    if PREFS:
        browser_params[i].prefs = json.loads(PREFS)
    # Set this value as appropriate for the size of your temp directory
    # if you are running out of space
    browser_params[i].maximum_profile_size = 500 * (10**20)  # 500 MB = 500 * 2^20 Bytes

# Update TaskManager configuration (use this for crawl-wide settings)
manager_params.data_directory = Path("./datadir/")
manager_params.log_path = Path("./datadir/openwpm.log")
manager_params.screenshot_path = Path("./datadir/screenshots/")

# memory_watchdog and process_watchdog are useful for large scale cloud crawls.
# Please refer to docs/Configuration.md#platform-configuration-options for more information
# manager_params.memory_watchdog = True
# manager_params.process_watchdog = True


# Commands time out by default after 30 seconds
with TaskManager(
    manager_params,
    browser_params,
    SQLiteStorageProvider(Path("./datadir/crawl-data.sqlite")),
    LevelDbProvider(Path("./datadir/crawl-data.leveldb"))
) as manager:
    # Visits the sites
    for index, site in enumerate(sites):

        def callback(success: bool, val: str = site) -> None:
            print(
                f"CommandSequence for {val} ran {'successfully' if success else 'unsuccessfully'}"
            )

        # Parallelize sites over all number of browsers set above.
        command_sequence: CommandSequence = CommandSequence(
            site,
            site_rank=index,
            callback=callback,
            reset=True
        )

        # Start by visiting the page
        command_sequence.append_command(GetCommand(url=site, sleep=3), timeout=60)
        #command_sequence.append_command(ScreenshotFullPageCommand(suffix=""), timeout=60)

        # Run commands across all browsers (simple parallelization)
        manager.execute_command_sequence(command_sequence)
