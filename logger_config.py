"""
Logging configuration module
Provides centralized logging setup with file rotation
"""
import logging
import os
from logging.handlers import RotatingFileHandler
from datetime import datetime


def setup_logging(log_dir="logs", log_level=logging.INFO):
    """
    Setup logging configuration with file rotation
    
    Args:
        log_dir: Directory to store log files
        log_level: Logging level (default: INFO)
    """
    # Create logs directory if not exists
    if not os.path.exists(log_dir):
        os.makedirs(log_dir)
    
    # Generate log filename with date
    log_filename = os.path.join(log_dir, f"amq2api_{datetime.now().strftime('%Y%m%d')}.log")
    
    # Create formatters
    detailed_formatter = logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - [%(filename)s:%(lineno)d] - %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )
    
    simple_formatter = logging.Formatter(
        '%(asctime)s - %(levelname)s - %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )
    
    # File handler with rotation (max 10MB per file, keep 10 files)
    file_handler = RotatingFileHandler(
        log_filename,
        maxBytes=10*1024*1024,  # 10MB
        backupCount=10,
        encoding='utf-8'
    )
    file_handler.setLevel(log_level)
    file_handler.setFormatter(detailed_formatter)
    
    # Console handler
    console_handler = logging.StreamHandler()
    console_handler.setLevel(log_level)
    console_handler.setFormatter(simple_formatter)
    
    # Error log file (separate file for errors only)
    error_log_filename = os.path.join(log_dir, f"amq2api_error_{datetime.now().strftime('%Y%m%d')}.log")
    error_handler = RotatingFileHandler(
        error_log_filename,
        maxBytes=10*1024*1024,
        backupCount=5,
        encoding='utf-8'
    )
    error_handler.setLevel(logging.ERROR)
    error_handler.setFormatter(detailed_formatter)
    
    # Configure root logger
    root_logger = logging.getLogger()
    root_logger.setLevel(log_level)
    
    # Remove existing handlers
    root_logger.handlers.clear()
    
    # Add handlers
    root_logger.addHandler(file_handler)
    root_logger.addHandler(console_handler)
    root_logger.addHandler(error_handler)
    
    # Log startup message
    logging.info("=" * 80)
    logging.info("Logging system initialized")
    logging.info(f"Log directory: {os.path.abspath(log_dir)}")
    logging.info(f"Main log file: {log_filename}")
    logging.info(f"Error log file: {error_log_filename}")
    logging.info(f"Log level: {logging.getLevelName(log_level)}")
    logging.info("=" * 80)
    
    return root_logger


def get_logger(name):
    """
    Get a logger instance
    
    Args:
        name: Logger name (usually __name__)
    
    Returns:
        Logger instance
    """
    return logging.getLogger(name)
